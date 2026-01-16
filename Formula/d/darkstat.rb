class Darkstat < Formula
  desc "Network traffic analyzer"
  homepage "https://unix4lyfe.org/darkstat/"
  url "https://github.com/emikulic/darkstat/archive/refs/tags/3.0.722.tar.gz"
  sha256 "5c8e66d4c478b6d7e58f4c842823a09125509bf6851017ff70e32b32ce95b01b"
  license all_of: ["BSD-4-Clause-UC", "GPL-2.0-only", "GPL-3.0-or-later", "X11"]
  head "https://github.com/emikulic/darkstat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3dd43f8c27edbf9e7ee2d7769cb50512977b31ea1519a6c14e3bdc8777364519"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9303731ebb9fd40e5c9a4260103eab5442b2cf96228b11d3a4a139271d6da972"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c69728d3c494174d2e4ed2a260acc4217e0d759dd488881d5a78cd40e76d140"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba08516ebe6c57072222ca80429a0a14cf94b898c0de73f940b215ae80af3ef1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81a77615427806e270297ddeca7d4c126952a4ffd83a362d87675d2b5e00e650"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59ec9f41c65df91ffc821e53c8f36a3eade1dd7cf7ead1003d0852f432cdcde7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "libpcap"
  uses_from_macos "zlib"

  # Patch reported to upstream on 2017-10-08
  # Work around `redefinition of clockid_t` issue on 10.12 SDK or newer
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/darkstat/clock_gettime.patch"
    sha256 "001b81d417a802f16c5bc4577c3b840799511a79ceedec27fc7ff1273df1018b"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system sbin/"darkstat", "--verbose", "-r", test_fixtures("test.pcap")
  end
end
