class Ballerburg < Formula
  desc "Castle combat game"
  homepage "https://baller.tuxfamily.org/"
  url "https://download.tuxfamily.org/baller/ballerburg-1.2.2.tar.gz"
  sha256 "8e001efa44b70a9a51041a6ce39a2b01d9d3135d2ec54ca54196fc34f164914e"
  license "GPL-3.0-or-later"
  head "https://git.tuxfamily.org/baller/baller.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?ballerburg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "18e27b920964203d30abe78eaf1ad8b3542b9ad1dca97303841f0cf2a83f0b8d"
    sha256 cellar: :any,                 arm64_sonoma:   "6e60dfeb0525cbff53762cb9e529a15d87c4e48988e84c6884ed8b582944d5c6"
    sha256 cellar: :any,                 arm64_ventura:  "01fbf1c2eddb7cd5b18b44dbfdd5faaf0f5a774dbb41600af52066decedccd99"
    sha256 cellar: :any,                 arm64_monterey: "b752e6592084f8d57b5c23c616305ef53486884c35f2c18da3d81a18a1e3b6d6"
    sha256 cellar: :any,                 sonoma:         "527b34086caa339bc5e3bfa3f911aacedf0cd420a64522c77d09b75cd5d19465"
    sha256 cellar: :any,                 ventura:        "7e840cfda17d76b404136e80cda808e8049fb9d710c013d17290d85fe8270b48"
    sha256 cellar: :any,                 monterey:       "0ab3dfc0ea9f8f0e116794c913b9dbd393d0018a598d0ea2ba180d18dd5e25e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52a20fccf1c95f7d72148a613968943963d16e341e344431ff155a42bc65d05a"
  end

  depends_on "cmake" => :build
  depends_on "sdl2"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end
end
