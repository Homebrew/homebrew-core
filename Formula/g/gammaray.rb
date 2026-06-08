class Gammaray < Formula
  desc "Examine and manipulate Qt application internals at runtime"
  homepage "https://www.kdab.com/software-technologies/developer-tools/gammaray/"
  url "https://github.com/KDAB/GammaRay/releases/download/v3.4.0/gammaray-3.4.0.tar.gz"
  sha256 "bcac8aa24671bcfd563213f5cfd9e61cf555b22ee3896e8111a5c3a588aacadf"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/KDAB/GammaRay.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ff1decfe3cc1d862994986778991e84acaa926d6a37b3d9486bc6a39c6cf5be0"
    sha256 cellar: :any,                 arm64_sequoia: "db8abb64ef79a55855e67f267042a3d39b9fce11cac7bdc33317fd166258acf9"
    sha256 cellar: :any,                 arm64_sonoma:  "a1162b20b59cd51a0a880e1608ba3a2b398d17894b7a5a880666d3a6a88940a9"
    sha256 cellar: :any,                 sonoma:        "4e20b999b1312561b0edfc160167ca20ff7adabafefb02f28176110d13f6f1b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d23ddb514491d80bcbe46f3fd32d72a74ccfff0cab3667f9344bf4f7e3bef19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e01581312d2f1d927a2b0f1e4bca488cf57a761f30d1035a8c34e53bf035f3a"
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

  # Make rootPath follow symlink to support linked keg.
  # Submitted upstream: https://github.com/KDAB/GammaRay/pull/1126
  patch do
    url "https://github.com/KDAB/GammaRay/commit/23e98b93e4e430806a43f6cfa5b1dd0ee1ee1c80.patch?full_index=1"
    sha256 "aed9d33a97b4c2dbe11eaff0d06554aa4f80fc2ca10e0f34f1a55526da79423a"
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
