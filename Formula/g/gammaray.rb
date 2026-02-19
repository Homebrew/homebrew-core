class Gammaray < Formula
  desc "Examine and manipulate Qt application internals at runtime"
  homepage "https://www.kdab.com/software-technologies/developer-tools/gammaray/"
  url "https://github.com/KDAB/GammaRay/releases/download/v3.3.1/gammaray-3.3.1.tar.gz"
  sha256 "270b35239f2473f9c9cded13498ddb8af82d589bf6518db776d837a73c9441d8"
  license "GPL-2.0-or-later"
  head "https://github.com/KDAB/GammaRay.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "548f1b1234dffac56c3fade64c058b10211bd3fe6233c0d5b943a434fc0a892e"
    sha256 cellar: :any,                 arm64_sequoia: "15787896f62185c08e7baea63a43f3620e4228bb7582cca8c76e2315c9663e66"
    sha256 cellar: :any,                 arm64_sonoma:  "72a180b812ae7beb9aed13751ace665085ac0ecca3b6d294800c73f524254248"
    sha256 cellar: :any,                 sonoma:        "8aa40d7ff44dd50ca11862f7c158433f994f005e7f37ddddedfd39af0ec24511"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "856a70289b82714039cbc47a75ba66f657a0a70e290d00b9a4a80110bfedea4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "686dcbd9dd392b9405eb9d41dde205cd4a53889435f580d8d97cead1c033b235"
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
    rpaths = [rpath]
    # Workaround to stop brew from complaining about missing RPATH
    rpaths << "#{loader_path}/../../../../../../Frameworks" if OS.mac?

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_DISABLE_FIND_PACKAGE_Graphviz=ON",
                    "-DCMAKE_DISABLE_FIND_PACKAGE_VTK=OFF",
                    "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    gammaray = OS.mac? ? prefix/"GammaRay.app/Contents/MacOS/gammaray" : bin/"gammaray"
    assert_predicate gammaray, :executable?
  end
end
