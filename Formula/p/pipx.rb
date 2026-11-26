class Pipx < Formula
  include Language::Python::Virtualenv

  desc "Execute binaries from Python packages in isolated environments"
  homepage "https://pipx.pypa.io"
  url "https://files.pythonhosted.org/packages/51/18/db2093a6337de90daad9937e9dce5e8bde7fe077cf678f75baa1111f3956/pipx-1.19.1.tar.gz"
  sha256 "fd654c9468cf5238fae49bb0c924a863ebb8237dd4635855f08cbb010aec0196"
  license "MIT"
  head "https://github.com/pypa/pipx.git", branch: "main"

  bottle do
    manifest_sha256 "2be84bec97e1f1e12b7f82475e9de938869d8c9ba1970de520aeab4fd6674fcf"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e1766d9a465f72b4e6e2758510abf4d36acb9246786840ebb58f4db1bed5fccb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e1766d9a465f72b4e6e2758510abf4d36acb9246786840ebb58f4db1bed5fccb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e1766d9a465f72b4e6e2758510abf4d36acb9246786840ebb58f4db1bed5fccb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f65914cd6f91b5e2a07cd9021cbdbcf1e5b696a863f8be2c5543b115c4632372"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f65914cd6f91b5e2a07cd9021cbdbcf1e5b696a863f8be2c5543b115c4632372"
  end

  depends_on "python@3.15"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/19/0d/ca63f1b8b706c70590d0a4acc9c3c94ea8ed4dd9c83b4f7af195868abe76/argcomplete-3.8.0.tar.gz"
    sha256 "0114d634013e11ac92cc329b3a7d886c3506e98ddc7bb23c99b1782aacc8b8bd"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/45/37/edbf1b0707709013c0cf2e8317e03d97ed29bf4cac709fe328904ae92a38/click-8.5.1.tar.gz"
    sha256 "9bbfada76703fd1d784b83eea012e3e8c6a001a876543ef104fa56aaaeb072b4"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/e6/86/a5b9ec254b90efb180e390e31a4fa50a93b714d6e4174fa9a4ee25607159/filelock-4.3.1.tar.gz"
    sha256 "4c5ee627c401f1863ac6a0de9a14a28d3bb5f8c730b45e2fd6e5dbc79cf34b9e"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/c3/75/ffb1dc0ed12352139fb4ca0e3fde4325a23e3d0f3f40efe89717bc4f557b/packaging-26.4.tar.gz"
    sha256 "c4b671c41ddb9bf26e543c37723610d28fb6bf7affc4da17cf048d419d2c062a"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/71/18/0b0d99f5bf164f04a7a9534c3dbdbe4d5fd2b382667685ad40c192c4d3d1/platformdirs-4.14.8.tar.gz"
    sha256 "96893d686e84e9e6f358a9ea41a8de544df66dbf2ba6cda250e7dc73acf85b9b"
  end

  resource "userpath" do
    url "https://files.pythonhosted.org/packages/d5/b7/30753098208505d7ff9be5b3a32112fb8a4cb3ddfccbbb7ba9973f2e29ff/userpath-1.9.2.tar.gz"
    sha256 "6c52288dab069257cc831846d15d48133522455d4677ee69a9781f11dbefd815"
  end

  # downloads wheels during build and test
  deny_network_access! :postinstall

  def install
    # Avoid Cellar path reference, which is only good for one version.
    inreplace "src/pipx/interpreter.py", "return str(Path(sys.executable).resolve())",
                                         "return '#{python3}'"

    virtualenv_install_with_resources

    generate_completions_from_executable(libexec/"bin/register-python-argcomplete", "pipx",
                                         shell_parameter_format: :arg)
  end

  test do
    assert_match "PIPX_HOME", shell_output("#{bin}/pipx --help")
    system bin/"pipx", "install", "csvkit"
    assert_path_exists testpath/".local/bin/csvjoin"
    system bin/"pipx", "uninstall", "csvkit"
    refute_match "csvjoin", shell_output("#{bin}/pipx list")
  end
end
