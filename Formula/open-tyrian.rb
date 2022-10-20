class OpenTyrian < Formula
  desc "Open-source port of Tyrian"
  homepage "https://github.com/opentyrian/opentyrian"
  url "https://github.com/opentyrian/opentyrian/archive/refs/tags/v2.1.20220318.tar.gz"
  sha256 "e0c6afbb5d395c919f9202f4c9b3b4da7bd6e993e9da6152f995012577e1ccbd"
  license "GPL-2.0-or-later"
  head "https://github.com/opentyrian/opentyrian.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "39a8c8ce3eb29356265616c12f10d23fd1fab1384e2c14bb664594111d2daaa0"
    sha256 arm64_big_sur:  "b4d5f6274b1ea73030ec283ceae442a11b82b461514ceead9d1cfb6d835d0976"
    sha256 monterey:       "4b9fdf300031dd097e1e204a65db08ead73e5139d6e43571eebdd60e07298a5a"
    sha256 big_sur:        "b815a24ff59c0748826dc34b72d691dd4d3a48fdf5ee5650650a7f89c7087d63"
    sha256 catalina:       "e537f93b6c659004897ae34ee7a21741a2e66621cb09ae725042e6032435edef"
    sha256 x86_64_linux:   "d83c9e026139d4bd492da588dfa1f00976bee1ef11f4f76c2ea44bbc8d581e6f"
  end

  depends_on "pkg-config" => :build
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
    system "#{bin}/opentyrian", "--help"
  end
end
