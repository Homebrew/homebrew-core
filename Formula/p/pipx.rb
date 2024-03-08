class Pipx < Formula
  include Language::Python::Virtualenv

  desc "Execute binaries from Python packages in isolated environments"
  homepage "https://pipx.pypa.io"
  url "https://files.pythonhosted.org/packages/c6/8e/63d1bb26319d0fbb44b21fc068a7c0dab96e8516fbb2dd5f572f7ad178d2/pipx-1.4.3.tar.gz"
  sha256 "d214512bccc601b575de096ee84fde8797323717a20752c48f7a55cc1bf062fe"
  license "MIT"
  head "https://github.com/pypa/pipx.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dcb339771191ce2c1e033e95938f777d532d72964ae1ee74b52b579e0383a860"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dcb339771191ce2c1e033e95938f777d532d72964ae1ee74b52b579e0383a860"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dcb339771191ce2c1e033e95938f777d532d72964ae1ee74b52b579e0383a860"
    sha256 cellar: :any_skip_relocation, sonoma:         "d13936bd28f02aaf14727d046d875ff8161e469b7b093f4b89195e472325a9ae"
    sha256 cellar: :any_skip_relocation, ventura:        "d13936bd28f02aaf14727d046d875ff8161e469b7b093f4b89195e472325a9ae"
    sha256 cellar: :any_skip_relocation, monterey:       "d13936bd28f02aaf14727d046d875ff8161e469b7b093f4b89195e472325a9ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "630237186b85cda553a374ffd32ee7c37159adfdfb3883d50b63cc652dc863de"
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
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
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
