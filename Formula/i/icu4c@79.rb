class Icu4cAT79 < Formula
  desc "C/C++ and Java libraries for Unicode and globalization"
  homepage "https://icu.unicode.org/home"
  url "https://github.com/unicode-org/icu/releases/download/release-79.1/icu4c-79.1-sources.tgz"
  sha256 "06fa63ecb521048f8082f12ad988f6b678d90cbd88aafce24cbc94902b191d99"
  license "Unicode-3.0"
  compatibility_version 1

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
    sha256 cellar: :any, arm64_golden_gate: "8499235357ff52424e3fcc647a6ce57050af9f10904554df90319e6a088f665d"
    sha256 cellar: :any, arm64_tahoe:       "4424c58d257d07b28086814a575baa9e462560460fdea5455581d99062896cec"
    sha256 cellar: :any, arm64_sequoia:     "7d05da26db392a008abe89706adcf8b089e08d3431535ac95a5c984ceda88153"
    sha256 cellar: :any, arm64_linux:       "ebe1d075451ec91197686ccdefa5ca08210aa67cdbe1a9c967a081a34937fe21"
    sha256 cellar: :any, x86_64_linux:      "8e06c733d9e465f5151d7eb76a3e8b460c8ccfa8020da3ce2b8b5e2f45435c43"
  end

  keg_only :shadowed_by_macos, "macOS provides libicucore.dylib (but nothing else)"

  deny_network_access!

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

    inreplace [bin/"icu-config", *lib.glob("pkgconfig/icu-*.pc")], prefix, opt_prefix
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
