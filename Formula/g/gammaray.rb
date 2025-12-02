class Gammaray < Formula
  desc "Examine and manipulate Qt application internals at runtime"
  homepage "https://www.kdab.com/software-technologies/developer-tools/gammaray/"
  url "https://github.com/KDAB/GammaRay/releases/download/v3.3.1/gammaray-3.3.1.tar.gz"
  sha256 "270b35239f2473f9c9cded13498ddb8af82d589bf6518db776d837a73c9441d8"
  license "GPL-2.0-or-later"
  head "https://github.com/KDAB/GammaRay.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a58dd8c3adbbf4cf4127395428eb195052c14989cde9bbd5e29f479965ee79a5"
    sha256 cellar: :any,                 arm64_sequoia: "37e9dd000236cfc6c1d027a983e9f838072f6741daf70271e61c05cbfa339b08"
    sha256 cellar: :any,                 arm64_sonoma:  "f56397200c21df5d2429815218a5d4b569ac6a4fbef00e4863d53e786ed3c51d"
    sha256 cellar: :any,                 sonoma:        "dc2aa1d3beed9ed49bb2ecad0f7aeea98f54b7d3233e4f99a93077d7a517b6d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "232614a6b02a6fa02409a92feebc3fb07c32468efa6c7b2cd4a3387fbf84573e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b77cdb859be2653b5d1f4a03f0f7ada97ed19acd6c7a164e4ee15d6750f19f3"
  end

  depends_on "cmake" => :build
  depends_on "graphviz"
  depends_on "qt3d"
  depends_on "qtbase"
  depends_on "qtconnectivity"
  depends_on "qtdeclarative"
  depends_on "qtpositioning"
  depends_on "qtscxml"
  depends_on "qtsvg"
  depends_on "qttools"

  on_macos do
    depends_on "qtlocation"
    depends_on "qtwebchannel"
  end

  on_sonoma :or_newer do
    depends_on "qtwebengine"
  end

  on_linux do
    depends_on "elfutils"
    depends_on "qtwayland"
    depends_on "wayland"

    # TODO: Add dependencies on all Linux when `qtwebengine` is bottled on arm64 Linux
    on_intel do
      depends_on "qtwebengine"
    end
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_DISABLE_FIND_PACKAGE_Graphviz=ON",
                    "-DCMAKE_DISABLE_FIND_PACKAGE_VTK=OFF",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    gammaray = OS.mac? ? prefix/"GammaRay.app/Contents/MacOS/gammaray" : bin/"gammaray"
    assert_predicate gammaray, :executable?
  end
end
