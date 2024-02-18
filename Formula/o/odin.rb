class Odin < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https://odin-lang.org/"
  url "https://github.com/odin-lang/Odin.git",
      tag:      "dev-2024-02",
      revision: "539cec7496c128a0f8bb10794a1d3d0d043705f0"
  version "2024-02"
  license "BSD-3-Clause"
  head "https://github.com/odin-lang/Odin.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1c97bb6ee8fc71d77ca344f88934319c7776fb181a0d670bcd02a4abd87c8db0"
    sha256 cellar: :any,                 arm64_ventura:  "3897e5d89b6cbbf7a1af85d1c826636851d5e12a62009a46e6f741a59afdcd26"
    sha256 cellar: :any,                 arm64_monterey: "eec5672d096a0dcb9d7c2330a3d511ba584d85c64bda0721792a3b3fd9770d07"
    sha256 cellar: :any,                 sonoma:         "dc5767f7b34d00e952f6dafb07cd7e20a461397a10e7a5407179f34b97fe5adb"
    sha256 cellar: :any,                 ventura:        "e2a5b6d02c81c2e84807e1500f1ba05d27ea8ed2f5e3012ed01e1cb7420ee964"
    sha256 cellar: :any,                 monterey:       "12719f71ceb5b435adf6532522c1a9c1711844161ca9fc835f8ddfec5ccbf3b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43f62fc9cca1fad774659c6da3ce6a9ea23304318b88970e2509386b30e0d436"
  end

  depends_on "llvm"

  fails_with gcc: "5" # LLVM is built with GCC

  def install
    llvm = deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+(\.\d+)*)?$/) }

    # Keep version number consistent and reproducible for tagged releases.
    args = []
    args << "ODIN_VERSION=dev-#{version}" unless build.head?
    system "make", "release", *args
    libexec.install "odin", "core", "shared", "base"
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
    assert_equal "Hellope!\n", shell_output("./hellope")
  end
end
