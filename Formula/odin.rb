class Odin < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https://odin-lang.org/"
  url "https://github.com/odin-lang/Odin.git",
      tag:      "dev-2023-01",
      revision: "86511d44e46b6271b01df2cd1ebb83b5496e143c"
  version "2023-01"
  license "BSD-3-Clause"
  head "https://github.com/odin-lang/Odin.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ed3d9c4a12e75e0c363f60b6e687401c59ffcbb89f695e764b90d177597ac919"
    sha256 cellar: :any,                 arm64_monterey: "23b484fb4aa04ce35759b0717bf89129e02ae505e480100619f092c291d3dcbe"
    sha256 cellar: :any,                 arm64_big_sur:  "3c9de179adaca5e11e6b76cb8b3792f3659008f12199098039b1abfa8736cdfb"
    sha256 cellar: :any,                 ventura:        "00644ac5a1894bf46e3cce794f4a31990034b58f5dccabc8eb0f6fef702938cf"
    sha256 cellar: :any,                 monterey:       "9a961aa4b6b6197de829e7b4dc6c44f7c03aaf3e15e7a61ad65f2934511332e3"
    sha256 cellar: :any,                 big_sur:        "660965ee16226130e7f79eced3ba41fe5701e0922831f6bbef4243f22eb68321"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b64c113883fb0fe781bb494a37efd574e3700ec1fb202d7a3d41bbc03be12bb"
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
