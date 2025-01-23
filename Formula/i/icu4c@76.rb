class Icu4cAT76 < Formula
  desc "C/C++ and Java libraries for Unicode and globalization"
  homepage "https://icu.unicode.org/home"
  url "https://github.com/unicode-org/icu/releases/download/release-76-1/icu4c-76_1-src.tgz"
  version "76.1"
  sha256 "dfacb46bfe4747410472ce3e1144bf28a102feeaa4e3875bac9b4c6cf30f4f3e"
  license "ICU"
  revision 1

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
    sha256 cellar: :any,                 arm64_sequoia: "66a2995c046a7d78b727cac1b90f52a2fd3bcf07488ae41c711109bbd1fca8e1"
    sha256 cellar: :any,                 arm64_sonoma:  "38c00ad782ec16cf4c5b3439b15a38e11e8be3ffc5b029135cfff102e36bcfa3"
    sha256 cellar: :any,                 arm64_ventura: "2f7b9091aa04a8310a473037175e2242f3ef87526fb6914b9078c4002d6098e3"
    sha256 cellar: :any,                 sonoma:        "f7e042054dd71e1167f8c93bd64d817def4c229772a897de0e905e1566985fef"
    sha256 cellar: :any,                 ventura:       "49b0d34d41e6785b7324ec4fd8d503227b619941343379cfdb037b11f4fbf68b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e371567ddebb72c0aac6143d10bc47d6f0e0ed87aa7d3962a1ee8b6d86438f26"
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
