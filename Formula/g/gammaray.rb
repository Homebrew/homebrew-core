class Gammaray < Formula
  desc "Examine and manipulate Qt application internals at runtime"
  homepage "https://www.kdab.com/software-technologies/developer-tools/gammaray/"
  url "https://github.com/KDAB/GammaRay/releases/download/v3.4.0/gammaray-3.4.0.tar.gz"
  sha256 "bcac8aa24671bcfd563213f5cfd9e61cf555b22ee3896e8111a5c3a588aacadf"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/KDAB/GammaRay.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "c0223fd056506e3eabc4fdde27eca3ee0b7d95c2b2d8d3dee7c028f7344873b1"
    sha256 cellar: :any, arm64_sequoia: "1620f3ce5fc6abac6d87e80022ea773b496e13dc5b69191c1f45a89152577e54"
    sha256 cellar: :any, arm64_sonoma:  "1c69fefd316a5da83b5dcff89924fa549ecf66a9f8979fc4b4dcad760de528fe"
    sha256 cellar: :any, sonoma:        "81f1b1ed7c0eb5daf8c4504506911c5f5c0c90e9d026d5b030371f7d8a2d9e32"
    sha256 cellar: :any, arm64_linux:   "72277a6183c81c8e71994b248be74f1d5532dcfca6f7edbdd1b21a037c864ddc"
    sha256 cellar: :any, x86_64_linux:  "b5b2546e543d8565d1f487cba7b7a8eb974aff43da5f18f6a1d676e609533ddd"
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

  on_system :linux, macos: :sonoma_or_newer do
    depends_on "qtwebengine"
  end

  on_linux do
    depends_on "elfutils"
    depends_on "qtwayland"
    depends_on "wayland"
  end

  # Make rootPath follow symlink to support linked keg.
  patch do
    url "https://github.com/KDAB/GammaRay/commit/23e98b93e4e430806a43f6cfa5b1dd0ee1ee1c80.patch?full_index=1"
    sha256 "aed9d33a97b4c2dbe11eaff0d06554aa4f80fc2ca10e0f34f1a55526da79423a"
    type :backport
    resolves "https://github.com/KDAB/GammaRay/pull/1126"
  end

  def install
    rpaths = [rpath]
    # Workaround to stop brew from complaining about missing RPATH
    rpaths << rpath(source: prefix/"plugins/gammaray-target/position")

    inreplace "CMakeLists.txt", 'set(MAN_INSTALL_DIR "man/man1")', "set(MAN_INSTALL_DIR \"#{man1}\")" if OS.mac?

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_DISABLE_FIND_PACKAGE_Graphviz=ON",
                    "-DCMAKE_DISABLE_FIND_PACKAGE_VTK=OFF",
                    "-DGAMMARAY_INSTALL_QT_LAYOUT=ON",
                    "-DZSHAUTOCOMPLETE_INSTALL_DIR=#{zsh_completion}",
                    "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    ENV["QT_QPA_PLATFORM"] = "offscreen" if OS.linux?
    assert_match version.to_s, shell_output("#{bin}/gammaray --version")

    assert_match "successfully passed its self-test", shell_output("#{bin}/gammaray --self-test")
  end
end
