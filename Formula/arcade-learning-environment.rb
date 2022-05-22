class ArcadeLearningEnvironment < Formula
  include Language::Python::Virtualenv

  desc "Platform for AI research"
  homepage "https://github.com/mgbellemare/Arcade-Learning-Environment"
  url "https://github.com/mgbellemare/Arcade-Learning-Environment.git",
      tag:      "v0.7.5",
      revision: "db3728264f382402120913d76c4fa0dc320ef59f"
  license "GPL-2.0-only"
  head "https://github.com/mgbellemare/Arcade-Learning-Environment.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d2af5cc5f2142ae169ee8f084ee0dee9737387fe4d29b000800f3e6e9d7d9f92"
    sha256 cellar: :any,                 arm64_big_sur:  "cb88b66ecaf3b0d5f4fa48d9e168c55085380f378e7084653312bb7efde3533d"
    sha256 cellar: :any,                 monterey:       "0d727d6a027d45b8f06d60c80af02b34c0702a3b9bdcb186b1d10a28be5a6535"
    sha256 cellar: :any,                 big_sur:        "29832ccb62b2e63e7a70067ae1a9c5766caab4f1a40e9a1041847b8269a42d96"
    sha256 cellar: :any,                 catalina:       "6f70478d210592616e3a11e881ada9681943b35937694c90639f278f1c3f200d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96879a347e05c3f50da2fd59d3995fad10895d6bc39f964af5a963332128b6d8"
  end

  depends_on "cmake" => :build
  depends_on macos: :catalina # requires std::filesystem
  depends_on "numpy"
  depends_on "python@3.10"
  depends_on "sdl2"

  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc" # for C++17
  end

  fails_with gcc: "5"

  # Issue building with older setuptools currently included with Python 3.10.4.
  # TODO: remove after next python update
  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4a/25/ec29a23ef38b9456f9965c57a9e1221e6c246d87abbf2a31158799bca201/setuptools-62.3.2.tar.gz"
    sha256 "a43bdedf853c670e5fed28e5623403bad2f73cf02f9a2774e91def6bda8265a7"
  end

  resource "importlib-resources" do
    url "https://files.pythonhosted.org/packages/07/3c/4e27ef7d4cea5203ed4b52b7fe96ddd08559d9f147a2a4307e7d6d98c035/importlib_resources-5.7.1.tar.gz"
    sha256 "b6062987dfc51f0fcb809187cffbd60f35df7acb4589091f154214af6d0d49d3"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DCMAKE_INSTALL_NAME_DIR=#{opt_lib}",
                    "-DCMAKE_BUILD_WITH_INSTALL_NAME_DIR=ON",
                    "-DSDL_SUPPORT=ON",
                    "-DSDL_DYNLOAD=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "tests/resources/tetris.bin"

    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources

    # error: no member named 'signbit' in the global namespace
    inreplace "setup.py", "cmake_args = [", "\\0\"-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}\"," if OS.mac?

    # `venv.pip_install_and_link buildpath` fails to install scripts, so manually run setup.py instead
    bin_before = Dir[libexec/"bin/*"].to_set
    system libexec/"bin/python3", *Language::Python.setup_install_args(libexec)
    bin.install_symlink (Dir[libexec/"bin/*"].to_set - bin_before).to_a

    site_packages = Language::Python.site_packages("python3")
    pth_contents = "import site; site.addsitedir('#{libexec/site_packages}')\n"
    (prefix/site_packages/"homebrew-ale-py.pth").write pth_contents
  end

  test do
    output = shell_output("#{bin}/ale-import-roms 2>&1", 2)
    assert_match "one of the arguments --import-from-pkg romdir is required", output
    output = shell_output("#{bin}/ale-import-roms .").lines.last.chomp
    assert_equal "Imported 0 / 0 ROMs", output

    cp pkgshare/"tetris.bin", testpath
    output = shell_output("#{bin}/ale-import-roms --dry-run .").lines.first.chomp
    assert_match(/\[SUPPORTED\].*tetris\.bin/, output)

    (testpath/"test.py").write <<~EOS
      from ale_py import ALEInterface, SDL_SUPPORT
      assert SDL_SUPPORT

      ale = ALEInterface()
      ale.setInt("random_seed", 123)
      ale.loadROM("tetris.bin")
      assert len(ale.getLegalActionSet()) == 18
    EOS

    output = shell_output("#{Formula["python@3.10"].opt_bin}/python3 test.py 2>&1")
    assert_match <<~EOS, output
      Game console created:
        ROM file:  tetris.bin
        Cart Name: Tetris 2600 (Colin Hughes)
        Cart MD5:  b0e1ee07fbc73493eac5651a52f90f00
    EOS
    assert_match <<~EOS, output
      Running ROM file...
      Random seed is 123
    EOS
  end
end
