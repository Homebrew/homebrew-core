class Pipx < Formula
  include Language::Python::Virtualenv

  desc "Execute binaries from Python packages in isolated environments"
  homepage "https://pipx.pypa.io"
  url "https://files.pythonhosted.org/packages/5e/10/8f2e475617869a6c679e4a46df2e48ed26ae060b80e137adbb215a22dec5/pipx-1.18.19.tar.gz"
  sha256 "2ee63572a0ba01ebb977781db3ece8df61c66b750b9ee9ced3effdbca34da861"
  license "MIT"
  head "https://github.com/pypa/pipx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5211d22386dd43dce6d6db37abd349dba30a8e950828eaa6a0efe41302749bad"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5211d22386dd43dce6d6db37abd349dba30a8e950828eaa6a0efe41302749bad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5211d22386dd43dce6d6db37abd349dba30a8e950828eaa6a0efe41302749bad"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9c66d1ef4af76af004c476f4ab853947cda04f5b0ddcc08079b1ea3f688f7404"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "9c66d1ef4af76af004c476f4ab853947cda04f5b0ddcc08079b1ea3f688f7404"
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
    url "https://files.pythonhosted.org/packages/bf/9d/7ec738e68764703d07eb4da4b43aabf0ae6f969f34cb3792a88af400abc5/filelock-4.2.11.tar.gz"
    sha256 "0cb84119fb8dce17898e1f69c974d5019daa59c4d7656be390a5fa59ccced912"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d7/9a/8475be631fb33ca1466915e70fd594c42a4e84b512db650eaa14f90fe75d/platformdirs-4.14.5.tar.gz"
    sha256 "32e9921db7385aa8169bee4fe9501923e5715ba9fb7ea3b9c69b0d8e0639f7a1"
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
