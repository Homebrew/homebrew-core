class Gammaray < Formula
  desc "Examine and manipulate Qt application internals at runtime"
  homepage "https://www.kdab.com/software-technologies/developer-tools/gammaray/"
  url "https://github.com/KDAB/GammaRay/releases/download/v3.4.0/gammaray-3.4.0.tar.gz"
  sha256 "bcac8aa24671bcfd563213f5cfd9e61cf555b22ee3896e8111a5c3a588aacadf"
  license "GPL-2.0-or-later"
  head "https://github.com/KDAB/GammaRay.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c19a1b68812e0bb1532fcc58c22e807e6aa20a019b8d1a7fe8ca272a7275b340"
    sha256 cellar: :any,                 arm64_sequoia: "92ad089dc006f9eacf961c93fffb74dbf5d21a11622b965aeef3dccbd9cfd665"
    sha256 cellar: :any,                 arm64_sonoma:  "a606aa3274d822ab188c0e4f1a5a30438bd11fba03212928bc688bcf23821bf5"
    sha256 cellar: :any,                 sonoma:        "9ee8b02c93141d665fef7bd26941d4669faaf7bc6c150cf36d32152bfd4bcf8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b30b250ba0d8004020e2c2f11ccc4f530eb8a95e1985e4e4b1f3638920280007"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28019d16d212ca777431dbd65d214ecdeec0e10d92173f469db2e46c94946027"
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
