class Icemon < Formula
  desc "Icecream GUI Monitor"
  homepage "https://github.com/icecc/icemon"
  url "https://github.com/icecc/icemon/archive/v3.3.tar.gz"
  sha256 "3caf14731313c99967f6e4e11ff261b061e4e3d0c7ef7565e89b12e0307814ca"

  bottle do
    cellar :any
    sha256 "4a5b08e5bc831130b26e21e81456c56b01f3ca391ff822785fe4b2a9f005132e" => :catalina
    sha256 "0752b2d25bb1371bf42fd8a049b6c10d6e289d74cf6d9409dd9b268a4da70722" => :mojave
    sha256 "785d0af0e6f9900aa7bd1c60309385da28dee75380dd47a449286dae7e6c3df2" => :high_sierra
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
