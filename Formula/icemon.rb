class Icemon < Formula
  desc "Icecream GUI Monitor"
  homepage "https://github.com/icecc/icemon"
  url "https://github.com/icecc/icemon/archive/v3.3.tar.gz"
  sha256 "3caf14731313c99967f6e4e11ff261b061e4e3d0c7ef7565e89b12e0307814ca"

  bottle do
    cellar :any
    sha256 "176f261b4bae02fd8e2c7c682b56cd86c4f90359dc974f3f0b488576bfc34032" => :mojave
    sha256 "6e277aace22ab9b1a621959e4814d6423370627930243ad72098341565acd836" => :high_sierra
    sha256 "61661c9f07b2213878a9b61e3920ffc23ee8a6c918cf8b4235124a6a8d6e63a6" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "icecream"
  depends_on "lzo"
  depends_on "qt"

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
