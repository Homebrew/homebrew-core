class Nethogs < Formula
  desc "Net top tool grouping bandwidth per process"
  homepage "https://raboof.github.io/nethogs/"
  url "https://github.com/raboof/nethogs/archive/v0.8.7.tar.gz"
  sha256 "957d6afcc220dfbba44c819162f44818051c5b4fb793c47ba98294393986617d"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7bb8279f67ff45ea099cbb079aca0787666f98bd307a09f58e3089ec0eed797e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59ca360d633795f970278151bdb3c1a216cbd38f730a1ef87a40247cfae70a5e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8bc7e3c64c95cb630973707c7a0bbd38ffb05d01f750c0c9ca342aacaa4c4f1e"
    sha256 cellar: :any_skip_relocation, ventura:        "bc30be3873a9200346d0a6a0e52cd52a54ae3f504dec181b478d9a9f383ad1a9"
    sha256 cellar: :any_skip_relocation, monterey:       "6d4164c21109b7af5a40e4f6ab8f5938a8a13e415fb7fc2ab26082f88a1b2319"
    sha256 cellar: :any_skip_relocation, big_sur:        "02b86d804fd1346a681792ca116c0aa2576563b3fb980ea0b094fbcff9c323ae"
    sha256 cellar: :any_skip_relocation, catalina:       "f253c8798f68bce3fc2bd8222cd9059098c105e4a5607a8d2c138056192289c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8e0528292fd9515e0d56f1db637bf97727aa93209ea6211ae8152d8d47e0ff7"
  end

  uses_from_macos "libpcap"
  uses_from_macos "ncurses"

  def install
    ENV.append "CXXFLAGS", "-std=c++14"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Using -V because other nethogs commands need to be run as root
    system sbin/"nethogs", "-V"
  end
end
