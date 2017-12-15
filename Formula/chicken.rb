class Chicken < Formula
  desc "Compiler for the Scheme programming language"
  homepage "https://www.call-cc.org/"
  url "https://code.call-cc.org/releases/4.13.0/chicken-4.13.0.tar.gz"
  sha256 "add549619a31363d6608b39e0cf0e68b9d5e6ff2a719b5691ddeba57229c6c43"
  head "https://code.call-cc.org/git/chicken-core.git"

  bottle do
    sha256 "583db05a9ea136f0813a6d09c22cfd791664bb70334789a785f75413e6c6f3f0" => :high_sierra
    sha256 "a60a97a73b76bfdc0e37643e497719a21ac96039898a451035651adfcfc2abc6" => :sierra
    sha256 "a0ab41706f71d20b4f4340405c57bc30b84dccaa59058cbc155c2cb7e6cb8d09" => :el_capitan
    sha256 "5d2edcc2728ef961e98b44db1ae098269fb3cf6010595719ab6f01677e49b473" => :yosemite
  end

  def install
    ENV.deparallelize

    args = %W[
      PLATFORM=macosx
      PREFIX=#{prefix}
      C_COMPILER=#{ENV.cc}
      LIBRARIAN=ar
      POSTINSTALL_PROGRAM=install_name_tool
    ]

    # Sometimes chicken detects a 32-bit environment by mistake, causing errors,
    # see https://github.com/Homebrew/homebrew/issues/45648
    args << "ARCH=x86-64" if MacOS.prefer_64_bit?

    system "make", *args
    system "make", "install", *args
  end

  test do
    assert_equal "25", shell_output("#{bin}/csi -e '(print (* 5 5))'").strip
  end
end
