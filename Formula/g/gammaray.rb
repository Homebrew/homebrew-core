class Gammaray < Formula
  desc "Examine and manipulate Qt application internals at runtime"
  homepage "https://www.kdab.com/software-technologies/developer-tools/gammaray/"
  url "https://github.com/KDAB/GammaRay/releases/download/v3.3.0/gammaray-3.3.0.tar.gz"
  sha256 "03fda338025d31b6a2794550f090d538996bbb6f4888eab3acb39db5a17127a8"
  license "GPL-2.0-or-later"
  head "https://github.com/KDAB/GammaRay.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "dbd2e0542cd9ace17d401fe3d8c9f9b46a1b079706e873c3c8cb3bdd191058dc"
    sha256 cellar: :any,                 arm64_sequoia: "18b2f69234eb8bbbfa11473781744c70993d42bd7d190fdf5bc12eaab1c5c966"
    sha256 cellar: :any,                 arm64_sonoma:  "c480c1834c5797ebbb206e027df33b71a1270f41704a90227d0953323e80b104"
    sha256 cellar: :any,                 sonoma:        "e128937e5279792055d4f39c523aee1799da2f669574cc63ded19371cbb03ee4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "372c2f59fef6ce0f520487c7ed7b32a4ed6e01c15380b67e43269a92dfb71568"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ff0f1aa862a5fe5b8f418afd78d2e0d4631f84f3982ecb8951bd22750e7516e"
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
