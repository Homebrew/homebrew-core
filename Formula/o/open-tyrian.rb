class OpenTyrian < Formula
  desc "Open-source port of Tyrian"
  homepage "https://github.com/opentyrian/opentyrian"
  url "https://github.com/opentyrian/opentyrian/archive/refs/tags/v2.1.20221123.tar.gz"
  sha256 "e0e8a8b0d61de10a3a65789ace9ea8e8c5d8dc67f3e423d2c852d64da38aeeb9"
  license "GPL-2.0-or-later"
  head "https://github.com/opentyrian/opentyrian.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "f6dd404f14a99279b9ea9d9dcc7343e56e2094a329a4424340c361dcb523ca30"
    sha256 arm64_sequoia:  "7a860fc29e71e5a0fc1b97ca782c57d39eadde156b0d557880e840ac1a588e5f"
    sha256 arm64_sonoma:   "b35a65491b3b3e18929614588953e7d05c9a59ddc8037c3524a8d69f0da5a7a7"
    sha256 arm64_ventura:  "97b601296652fbd37fa910ae6ee874ebe3fd0d6a6744f4518b1dbdb77db31544"
    sha256 arm64_monterey: "fe7198245df131d6e19dfb50e409b8e22d069d36e9375932525cac283b0cf5f9"
    sha256 arm64_big_sur:  "bebfff0ef49176f0141b8c9d386609bd3ce2bb0dcbb6e2e2899c3fa1cefa481a"
    sha256 sonoma:         "d51dc11f8810d928b6c7e352a4e6542a2f7e65994b4bc703feb224f0c5e55fd8"
    sha256 ventura:        "f431ffcf00b5a2080fdb5918f80f0edd794050d1b2d2a7d3de4f6fbe2e059a13"
    sha256 monterey:       "dd82b9fb887fb98fc009442c650b35a16c486d20d0b8b1dac74cb43f102d670f"
    sha256 big_sur:        "16549c5626bed5dd265ee914b75075da381cc81e1883e2a09cf841d1acfaa920"
    sha256 catalina:       "e23f7e095081f02181e4f7c17f5d2165da83c99691fbdacf12b036e8adb8e803"
    sha256 arm64_linux:    "9031f900da6fba1bb5702d9c9dee4c128772f8c5012542aa0ed4d0c15fdb4b88"
    sha256 x86_64_linux:   "20d32afb8db3ce9038cdbc8424c16a081b93e0060ac43f35a3d62bcde0c54fbd"
  end

  depends_on "pkgconf" => :build
  depends_on "sdl2"
  depends_on "sdl2_net"

  resource "homebrew-test-data" do
    url "https://camanis.net/tyrian/tyrian21.zip"
    sha256 "7790d09a2a3addcd33c66ef063d5900eb81cc9c342f4807eb8356364dd1d9277"
  end

  def install
    datadir = pkgshare/"data"
    datadir.install resource("homebrew-test-data")
    system "make", "TYRIAN_DIR=#{datadir}"
    bin.install "opentyrian"
  end

  def caveats
    "Save games will be put in ~/.opentyrian"
  end

  test do
    system bin/"opentyrian", "--help"
  end
end
