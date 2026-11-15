class Icu4cAT78 < Formula
  desc "C/C++ and Java libraries for Unicode and globalization"
  homepage "https://icu.unicode.org/home"
  url "https://github.com/unicode-org/icu/releases/download/release-78.3/icu4c-78.3-sources.tgz"
  sha256 "3a2e7a47604ba702f345878308e6fefeca612ee895cf4a5f222e7955fabfe0c0"
  license "Unicode-3.0"
  revision 1
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^release[._-]v?(78(?:[.-]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("-", ".") }
    end
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "aa02ab2fceec7d651d424608d74bf58d7a2561c715ca1ac302342abc103c82f3"
    sha256 cellar: :any, arm64_tahoe:       "91443211e1f1681ac6a0b6490a542e849176172a63f875704f51c03aa6dcaeb5"
    sha256 cellar: :any, arm64_sequoia:     "734f061857f642065372351d05fb8f1c8c2b9dc379aa8844fcdb702c0682ef81"
    sha256 cellar: :any, arm64_linux:       "87c02697af512c80fd292b8cc687c4403e8bebaf2098618d55644c197ee7caf7"
    sha256 cellar: :any, x86_64_linux:      "462bd64d4a899c4d031f7af2e58d5ddee82257e78a6703f5d43600d33fa29032"
  end

  keg_only :versioned_formula

  deprecate! date: "2026-10-30", because: :versioned_formula
  disable! date: "2027-10-30", because: :versioned_formula

  deny_network_access!

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
