class Odin < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https://odin-lang.org/"
  url "https://github.com/odin-lang/Odin.git",
      tag:      "dev-2022-12",
      revision: "521ed286321a30e5742a432effefb2c98b9484a7"
  version "2022-12"
  license "BSD-3-Clause"
  head "https://github.com/odin-lang/Odin.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "733feaa92759d2b66cfc61a503011bb10cf3b83c8377000e952453e6388c4db6"
    sha256 cellar: :any,                 arm64_monterey: "59aa458fabfac60adbe9229556022f2139ee1c99925bf242b518b62402809ae8"
    sha256 cellar: :any,                 arm64_big_sur:  "b4db4322d91a616173a3454d46d40ac15c37b52ce4b4a38effdf26f7dd6bfaf5"
    sha256 cellar: :any,                 ventura:        "4cacf29e5f58960ecdcd023de9288c197ea631e9542a786917f99d9229fd443d"
    sha256 cellar: :any,                 monterey:       "31613eb73b14283a127ab6b1975715c802c34e4e0636a785816440669d1f0e63"
    sha256 cellar: :any,                 big_sur:        "be00af3f548d58d94f073fbceb562f83996c1be39fc6335ba507e848cc11fbac"
    sha256 cellar: :any,                 catalina:       "3576c9ff57989433ebd7de0d113bfdf84b11052a27a9d741bb298760da44a02e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d75acd24a5e331c4426513dd948f85d05fba4003cd3dd74f41451ac20f3e921"
  end

  depends_on "llvm@14"

  fails_with gcc: "5" # LLVM is built with GCC

  def install
    llvm = deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+(\.\d+)*)?$/) }

    # Keep version number consistent and reproducible for tagged releases.
    # Issue ref: https://github.com/odin-lang/Odin/issues/1772
    inreplace "build_odin.sh", "dev-$(date +\"%Y-%m\")", "dev-#{version}" unless build.head?

    system "make", "release"
    libexec.install "odin", "core", "shared"
    (bin/"odin").write <<~EOS
      #!/bin/bash
      export PATH="#{llvm.opt_bin}:$PATH"
      exec -a odin "#{libexec}/odin" "$@"
    EOS
    pkgshare.install "examples"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/odin version")

    (testpath/"hellope.odin").write <<~EOS
      package main

      import "core:fmt"

      main :: proc() {
        fmt.println("Hellope!");
      }
    EOS
    system "#{bin}/odin", "build", "hellope.odin", "-file"
    assert_equal "Hellope!\n", shell_output("./hellope.bin")
  end
end
