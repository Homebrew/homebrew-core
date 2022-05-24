class Flac123 < Formula
  desc "Command-line program for playing FLAC audio files"
  homepage "https://flac-tools.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/flac-tools/flac123/flac123-0.0.12-release.tar.gz"
  sha256 "1976efd54a918eadd3cb10b34c77cee009e21ae56274148afa01edf32654e47d"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9e8e7554170d4be1bf7bc9ae5444b1773df9a3b884b5a58c64ed740f785975d3"
    sha256 cellar: :any,                 arm64_big_sur:  "beb35321efa9b0d023ede66ba6e8df9e906da354d654088a48e147f9f5c5dd6a"
    sha256 cellar: :any,                 big_sur:        "898d28a19dd90787cf49ecb1af955f7f65da13423f5bbfdc43a1fd0c6993c4d0"
    sha256 cellar: :any,                 catalina:       "e9d6f0e34bf00197859eb997f353123f67a75d644ed9a3dba400207a83a18d6b"
    sha256 cellar: :any,                 mojave:         "c1aa5158e16136453e09b384480a6aa4faaefc818c14243a0c4b5359cdab2fb4"
    sha256 cellar: :any,                 high_sierra:    "ac4ee518533f4b043fd380d0ed6e2077ec410c16acdf952b733df533a4750889"
    sha256 cellar: :any,                 sierra:         "f62d8e1f08e8cd5d952f02a35ebcdc921a1295035a2b66e843d80aacb8d9843e"
    sha256 cellar: :any,                 el_capitan:     "669b5ff8922496fe8abe8b020ef92118847539095a0d281f73b85e965be1f708"
    sha256 cellar: :any,                 yosemite:       "3bc22230d8e4ed12c794a0784173e576d17cfae249bb87d4540680d3f0483957"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "702b567f7ccf2066b130b9356b5e84f0642b000e4c5622b87300eaa6c28b2b99"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  depends_on "flac"
  depends_on "libao"
  depends_on "libogg"
  depends_on "popt"

  def install
    ENV["ACLOCAL"] = "aclocal"
    ENV["AUTOMAKE"] = "automake"
    system "aclocal"
    system "automake", "--add-missing"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install", "CC=#{ENV.cc}"
  end

  test do
    driver = OS.mac? ? "macosx" : "oss"
    system "#{bin}/flac123", "-d=#{driver}"
  end
end
