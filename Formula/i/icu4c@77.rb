class Icu4cAT77 < Formula
  desc "C/C++ and Java libraries for Unicode and globalization"
  homepage "https://icu.unicode.org/home"
  url "https://github.com/unicode-org/icu/releases/download/release-77-1/icu4c-77_1-src.tgz"
  version "77.1"
  sha256 "588e431f77327c39031ffbb8843c0e3bc122c211374485fa87dc5f3faff24061"
  license "ICU"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e48aa1a83777472421aeeb4d8163fed5b6012c4882b6024e3025edff3dde69f7"
    sha256 cellar: :any,                 arm64_sequoia: "d81c23dafe82a94efc115335fd292b849fa8e4809bb333764971e8f20001ded8"
    sha256 cellar: :any,                 arm64_sonoma:  "9cdb1eeea1514d12a167a01688b43072ed358e8a0df0e1110e123cc13d214210"
    sha256 cellar: :any,                 sonoma:        "919cc9bb093792d0a37354eb95974feec4d36c89b422484ac1b83f142a8780c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7cb1b29d05dbb75baf6068403a8b04131e5d0eb5ac0d36da8453506908ee6a46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab9144b3d86a3f6ddee00e53aa7d0aa6ea6d0037f454078f6dd1b336057679ee"
  end

  keg_only :versioned_formula

  def install
    args = %w[
      --disable-samples
      --disable-tests
      --enable-static
      --with-library-bits=64
    ]

    cd "source" do
      system "./configure", *args, *std_configure_args
      system "make"
      system "make", "install"
    end
  end

  test do
    if File.exist? "/usr/share/dict/words"
      system bin/"gendict", "--uchars", "/usr/share/dict/words", "dict"
    else
      (testpath/"hello").write "hello\nworld\n"
      system bin/"gendict", "--uchars", "hello", "dict"
    end
  end
end
