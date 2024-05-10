class Pipx < Formula
  include Language::Python::Virtualenv

  desc "Execute binaries from Python packages in isolated environments"
  homepage "https://pipx.pypa.io"
  url "https://files.pythonhosted.org/packages/97/a2/901a10ebedc68c12e686ac79f2d981fb748dd41fc54414bc408e502b8db0/pipx-1.5.0.tar.gz"
  sha256 "2371af2b772954cdb5c1dbfa0170219e3d2c09d9ff9b18e975f65562eeb7ab0a"
  license "MIT"
  head "https://github.com/pypa/pipx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4eeb10e6e0f2c20257b16b6120ed28eb7aa385c5ccb945c96afd1ba19eadcbd3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4eeb10e6e0f2c20257b16b6120ed28eb7aa385c5ccb945c96afd1ba19eadcbd3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4eeb10e6e0f2c20257b16b6120ed28eb7aa385c5ccb945c96afd1ba19eadcbd3"
    sha256 cellar: :any_skip_relocation, sonoma:         "7d4933915439d253111273efb335b5e02406baa3cf42e327f8e584fbb2fd745e"
    sha256 cellar: :any_skip_relocation, ventura:        "7d4933915439d253111273efb335b5e02406baa3cf42e327f8e584fbb2fd745e"
    sha256 cellar: :any_skip_relocation, monterey:       "7d4933915439d253111273efb335b5e02406baa3cf42e327f8e584fbb2fd745e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "829827a8519675630134deac488e0181c7fc79d29a51c2e68ade6f4b684c36e3"
  end

  depends_on "python@3.12"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/3c/c0/031c507227ce3b715274c1cd1f3f9baf7a0f7cec075e22c7c8b5d4e468a9/argcomplete-3.2.3.tar.gz"
    sha256 "bf7900329262e481be5a15f56f19736b376df6f82ed27576fa893652c5de6c23"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/96/dc/c1d911bf5bb0fdc58cc05010e9f3efe3b67970cef779ba7fbc3183b987a8/platformdirs-4.2.0.tar.gz"
    sha256 "ef0cc731df711022c174543cb70a9b5bd22e5a9337c8624ef2c2ceb8ddad8768"
  end

  resource "userpath" do
    url "https://files.pythonhosted.org/packages/d5/b7/30753098208505d7ff9be5b3a32112fb8a4cb3ddfccbbb7ba9973f2e29ff/userpath-1.9.2.tar.gz"
    sha256 "6c52288dab069257cc831846d15d48133522455d4677ee69a9781f11dbefd815"
  end

  def python3
    deps.map(&:to_formula)
        .find { |f| f.name.start_with?("python@") }
  end

  def install
    # Avoid Cellar path reference, which is only good for one version.
    inreplace "src/pipx/interpreter.py",
              "DEFAULT_PYTHON = _get_sys_executable()",
              "DEFAULT_PYTHON = '#{python3.opt_libexec/"bin/python"}'"

    virtualenv_install_with_resources

    generate_completions_from_executable(libexec/"bin/register-python-argcomplete", "pipx",
                                         shell_parameter_format: :arg)
  end

  test do
    assert_match "PIPX_HOME", shell_output("#{bin}/pipx --help")
    system bin/"pipx", "install", "csvkit"
    assert_predicate testpath/".local/bin/csvjoin", :exist?
    system bin/"pipx", "uninstall", "csvkit"
    refute_match "csvjoin", shell_output("#{bin}/pipx list")
  end
end
