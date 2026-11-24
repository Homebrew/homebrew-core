class Pipx < Formula
  include Language::Python::Virtualenv

  desc "Execute binaries from Python packages in isolated environments"
  homepage "https://pipx.pypa.io"
  url "https://files.pythonhosted.org/packages/db/3d/987759d8bfeaa834a92fae4dd680849c36fa048c57fad7915012848c076e/pipx-1.19.0.tar.gz"
  sha256 "9db512f0553b81f3227ab2613fabefc4fde8a51b3834b11add3ff5a026191361"
  license "MIT"
  head "https://github.com/pypa/pipx.git", branch: "main"

  bottle do
    rebuild 1
    manifest_sha256 "afbeff85688650cb0317031a87c6fc3008ec7bcd79a3f909d77582b9cac175f7"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "177334d439e4068a6237fe82b55785650c18637c84005c55015e698fe0e7ec50"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "177334d439e4068a6237fe82b55785650c18637c84005c55015e698fe0e7ec50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "177334d439e4068a6237fe82b55785650c18637c84005c55015e698fe0e7ec50"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0fd288a72c34e2f64fd8d6cf68a19316c098f82a2002910f49874aaad803e18d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "0fd288a72c34e2f64fd8d6cf68a19316c098f82a2002910f49874aaad803e18d"
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
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
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
