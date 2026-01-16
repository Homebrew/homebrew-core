class Icu4cAT78 < Formula
  desc "C/C++ and Java libraries for Unicode and globalization"
  homepage "https://icu.unicode.org/home"
  url "https://github.com/unicode-org/icu/releases/download/release-78.2/icu4c-78.2-sources.tgz"
  sha256 "3e99687b5c435d4b209630e2d2ebb79906c984685e78635078b672e03c89df35"
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
    sha256 cellar: :any,                 arm64_tahoe:   "dd21a03a000575112907785abf94f853facdf981442d0637605aa890a74c8181"
    sha256 cellar: :any,                 arm64_sequoia: "f153ba0774789f39daed4e3546ec6b2575ad742f7c71cf79ecb845f89bf9e70e"
    sha256 cellar: :any,                 arm64_sonoma:  "89115911782060dd1f716f987cd81be17dd6effc9f747b83c25d6f509ebce479"
    sha256 cellar: :any,                 sonoma:        "c07ff4225a3f67025780fc7c5bf2802a67897ae147b8d51d7e53531bc6d05b2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f52ad3ea43bfa3c16aac234217f0c0d6acc1787f5083d05c49213f12d5c097e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7aa8dc4368de2e9cd560ce809722ba32ad2292a0fe8459d3932f46325ce53427"
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
