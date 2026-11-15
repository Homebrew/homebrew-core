class Gammaray < Formula
  desc "Examine and manipulate Qt application internals at runtime"
  homepage "https://www.kdab.com/software-technologies/developer-tools/gammaray/"
  url "https://github.com/KDAB/GammaRay/releases/download/v3.4.1/gammaray-3.4.1.tar.gz"
  sha256 "f3b9e28a6d799a3b798e9e0dfde52481a9b8aa6aeb68c65890b3736731603740"
  license "GPL-2.0-or-later"
  head "https://github.com/KDAB/GammaRay.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7cc4d656ec29e288cde7f67ef54a6feedf8e579e0f8f10ec3028d35557e04704"
    sha256 cellar: :any, arm64_tahoe:       "3f8f07614cb0b93347c43efac6e6fd0252f66db651ea8c1dc543334043f6eb66"
    sha256 cellar: :any, arm64_sequoia:     "cee87e550ee7c82d1887372c330fc48d6042a7270bb4aead270632738ee7b4d4"
    sha256 cellar: :any, arm64_linux:       "453a344a0e9c931f6b1e722c390c46b8624cef02386a7c3706df7d70c4cdc499"
    sha256 cellar: :any, x86_64_linux:      "0014a99c8331d8d2eff449be0e96314ef7de35bb78947b0f79999ec47ef267e2"
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
