class Nickle < Formula
  desc "Desk calculator language"
  homepage "https://www.nickle.org/"
  url "https://nickle.org/release/nickle-2.103.tar.xz"
  sha256 "5ec34861d3888956bcb1d50bb3a917f6a53f228a967b88401afe8a9f0f2f36c0"
  license "MIT"

  livecheck do
    url "https://nickle.org/release/"
    regex(/href=.*?nickle[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "05fe04bd87e1683f8ade70c6b9ad53b59b958322151516fcbbc41b79fb9f2ad4"
    sha256 arm64_sonoma:  "c6c317696897c7ec062413e912e0c1826b05c1156bd8d824cd0d304fc66da361"
    sha256 arm64_ventura: "0fd866fe7d1ce93c062602166bdb78f23d361e2878d21484271d1779491d8151"
    sha256 sonoma:        "2b5f09ba8a23cebb6a8eeedc8b925b583ffb84dc3adc323be1c7ac97e50abbc3"
    sha256 ventura:       "97d9d0a48b9cd94f5b740fb2b4a7105807a0c38ace4362c681392fb34ba94ce8"
    sha256 arm64_linux:   "3ca75636c5293bde54e93fb922b6f3c34b0a9d698cffac1452902e0caff1033f"
    sha256 x86_64_linux:  "3e484518933728d2e31d47c464f9ae017dd79d06221c1d47aa500010d2a6d42e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "flex" => :build # conflicting types for 'yyget_leng'
  depends_on "pkgconf" => :build
  depends_on "readline"

  uses_from_macos "bison" => :build
  uses_from_macos "libedit"

  def install
    ENV["CC_FOR_BUILD"] = ENV.cc
    system "./autogen.sh", *std_configure_args
    system "make", "install"
  end

  test do
    assert_equal "4", shell_output("#{bin}/nickle -e '2+2'").chomp
  end
end
