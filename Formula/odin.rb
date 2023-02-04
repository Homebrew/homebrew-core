class Odin < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https://odin-lang.org/"
  url "https://github.com/odin-lang/Odin.git",
      tag:      "dev-2023-02",
      revision: "fcc920ed39c706240ef011fdba7fd1442b01b4d9"
  version "2023-02"
  license "BSD-3-Clause"
  head "https://github.com/odin-lang/Odin.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7de05cc0ff329c8e5f0bb1dbf1acd68a8b044300f6b62b56eb17389f5d727f84"
    sha256 cellar: :any,                 arm64_monterey: "8ebd487b6802b816ab9a592fa7b3a950c3f5cf7d9179fde4f7925da9afee5004"
    sha256 cellar: :any,                 arm64_big_sur:  "e3ed8de0a684f057c3fea6275019b1abcbca19e55e01b56fbe944481e066ebf8"
    sha256 cellar: :any,                 ventura:        "0f1b17e26f99997355a5658905400f3d793a3bd46334fe716e2999a2e2cf197e"
    sha256 cellar: :any,                 monterey:       "a090d2a65bbc3b25b802b8649848e099778c6048a06118c1c4f205f0ffad634f"
    sha256 cellar: :any,                 big_sur:        "8356cb570a64f4f00135dfa0d55e4611787640fe1ad8828f6d406687379fc6b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84910f364c8cde3c240b151752635f49b49c4baf68230c80252141d21a8529bc"
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
