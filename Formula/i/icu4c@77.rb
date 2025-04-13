class Icu4cAT77 < Formula
  desc "C/C++ and Java libraries for Unicode and globalization"
  homepage "https://icu.unicode.org/home"
  url "https://github.com/unicode-org/icu/releases/download/release-77-1/icu4c-77_1-src.tgz"
  version "77.1"
  sha256 "588e431f77327c39031ffbb8843c0e3bc122c211374485fa87dc5f3faff24061"
  license "ICU"

  # We allow the livecheck to detect new `icu4c` major versions in order to
  # automate version bumps. To make sure PRs are created correctly, we output
  # an error during installation to notify when a new formula is needed.
  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:[.-]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("-", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "19f6b5fef0cdf1dfc7f136ca103348ec8530ffdf8012273f6ee4a6159cdfaf75"
    sha256 cellar: :any,                 arm64_sonoma:  "f2b3a9d78e046b3b1ca1f06227272c0ea25490bd8efa4c98a33ffdcc734452ff"
    sha256 cellar: :any,                 arm64_ventura: "425a38eb7a7a1bb54dd25ac58194ef89d79caf1777a01fb244ed37487c1f7d80"
    sha256 cellar: :any,                 sonoma:        "54d609febedd08e8a4a825435d85f6d4db045f586523edb8965434e8e9c93fa6"
    sha256 cellar: :any,                 ventura:       "6f04d1757707495212ff68722bab629766329874ef7d0531e756903dff5022cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d633e676a17c418e7e1e6e58d41a7c61856f06cf198a3efa97e4a5489ab0196"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f82d4ca07fbdcf99cb5553ae9cf298bbff475a465f13e1c5d934dcbcb1e14741"
  end

  keg_only :shadowed_by_macos, "macOS provides libicucore.dylib (but nothing else)"

  def install
    odie "Major version bumps need a new formula!" if version.major.to_s != name[/@(\d+)$/, 1]

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
