class Icemon < Formula
  desc "Icecream GUI Monitor"
  homepage "https://github.com/icecc/icemon"
  url "https://github.com/icecc/icemon/archive/v3.3.tar.gz"
  sha256 "3caf14731313c99967f6e4e11ff261b061e4e3d0c7ef7565e89b12e0307814ca"
  license "GPL-2.0"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f310aad5e98a7cf3c6fca8a1ddcda9af425cb7b442512b5c540619de0312cb60"
    sha256 cellar: :any, big_sur:       "8db3861063efc1a5e53703b41993328968aa637ae4fed60112ac8ff4e364a422"
    sha256 cellar: :any, catalina:      "6a80f6cbc858fbc942c5845492ca6bfefdf2dd4f0746f97e28704301585f19aa"
    sha256 cellar: :any, mojave:        "34f8c691f2c2d23fc65bc84429f0282c96d47f88036ada6d6f44761287a88441"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "icecream"
  depends_on "lzo"
  depends_on "qt@5"

  resource "ecm" do
    url "https://github.com/KDE/extra-cmake-modules/archive/v5.62.0.tar.gz"
    sha256 "b3da80738ec793e8052819c53464244ff04a0705d92e8143b11d1918df9e970b"
  end

  def install
    resource("ecm").stage do
      cmake_args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] }
      system "cmake", ".",
        "-DCMAKE_INSTALL_PREFIX=#{buildpath}/ecm",
        *cmake_args
      system "make", "install"
    end
    system "cmake", ".", "-DECM_DIR=ecm/share/ECM/cmake", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/icemon", "--version"
  end
end
