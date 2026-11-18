class Pipx < Formula
  include Language::Python::Virtualenv

  desc "Execute binaries from Python packages in isolated environments"
  homepage "https://pipx.pypa.io"
  url "https://files.pythonhosted.org/packages/5e/10/8f2e475617869a6c679e4a46df2e48ed26ae060b80e137adbb215a22dec5/pipx-1.18.19.tar.gz"
  sha256 "2ee63572a0ba01ebb977781db3ece8df61c66b750b9ee9ced3effdbca34da861"
  license "MIT"
  head "https://github.com/pypa/pipx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0124b182115c02db1c1d378dc2130d50be3ba66a425bee6bed1f7e2f6ea985b3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0124b182115c02db1c1d378dc2130d50be3ba66a425bee6bed1f7e2f6ea985b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0124b182115c02db1c1d378dc2130d50be3ba66a425bee6bed1f7e2f6ea985b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "80085c4bfb7dee8ce92276e0466e2ca9183ddc71cb8da241ec6e0eac2849a02d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "80085c4bfb7dee8ce92276e0466e2ca9183ddc71cb8da241ec6e0eac2849a02d"
  end

  depends_on "python@3.15"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/87/6f/5a73f04007ca950701765949209f068da628bd11f9c2da287278ce91e0ee/argcomplete-3.7.2.tar.gz"
    sha256 "aad8b69a0b9969edb62db0d1752354c0d50717b10e0cbb00e2a958381b9fc6b9"
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

    venv = virtualenv_install_with_resources

    generate_completions_from_executable(libexec/"bin/register-python-argcomplete", "pipx",
                                         shell_parameter_format: :arg)

    # Build an `:all` bottle by replacing comments
    file = venv.site_packages.glob("argcomplete-*.dist-info/METADATA")
    inreplace file, "/opt/homebrew/bin/bash", "$HOMEBREW_PREFIX/bin/bash"
  end

  test do
    assert_match "PIPX_HOME", shell_output("#{bin}/pipx --help")
    system bin/"pipx", "install", "csvkit"
    assert_path_exists testpath/".local/bin/csvjoin"
    system bin/"pipx", "uninstall", "csvkit"
    refute_match "csvjoin", shell_output("#{bin}/pipx list")
  end
end
