class Gruyere < Formula
  include Language::Python::Virtualenv

  desc "TUI program for viewing and killing processes listening on ports"
  homepage "https://github.com/savannahostrowski/gruyere"
  url "https://files.pythonhosted.org/packages/16/0f/d951dda46ba3b3dcbdf14f55355130b016445f9aa6b021dd70a9a567026a/gruyere-0.1.0.tar.gz"
  sha256 "3fe1ff4eef9a53ed46f17a7aa5efa2eb0212a2c6de618c2b36735bcc71d358be"
  license "MIT"
  head "https://github.com/savannahostrowski/gruyere.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38e59a53fe749631456936a2c79fc30af4bc34af533a4ec2f20e811528f49bf9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30c9f7ce268b4189536406f2a336d17e80a686e9985ba8fdf8cc58bb0686fd0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42f7dbb6571a46dc17375cf5613cac6726e6430aefcd5a69841a0fc6950a7b1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e05129fb5fcecc61357d6af820594845fc615d93e9510f2ae46f52c6c6704ace"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0267dd435ea1b6f08e1769b004fb3d9fb5fb06664aeb61a9abf55087f2e73cb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f256ebbe7ed92eb18431ec9a9f89452075ab13eeb28732f8a08ef8e16ea917d"
  end

  depends_on "python@3.14"

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e1/88/bdd0a41e5857d5d703287598cbf08dad90aed56774ea52ae071bae9071b6/psutil-7.1.3.tar.gz"
    sha256 "6c86281738d77335af7aec228328e944b30930899ea760ecf33a4dba66be5e74"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "readchar" do
    url "https://files.pythonhosted.org/packages/dd/f8/8657b8cbb4ebeabfbdf991ac40eca8a1d1bd012011bd44ad1ed10f5cb494/readchar-4.2.1.tar.gz"
    sha256 "91ce3faf07688de14d800592951e5575e9c7a3213738ed01d394dcc949b79adb"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/fb/d2/8920e102050a0de7bfabeb4c4614a49248cf8d5d7a8d01885fbb24dc767a/rich-14.2.0.tar.gz"
    sha256 "73ff50c7c0c1c77c8243079283f4edb376f0f6442433aecb8ce7e6d0b92d1fe4"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/8f/28/7c85c8032b91dbe79725b6f17d2fffc595dff06a35c7a30a37bef73a1ab4/typer-0.20.0.tar.gz"
    sha256 "1aaf6494031793e4876fb0bacfa6a912b551cf43c1e63c800df8b1a866720c37"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"gruyere", shell_parameter_format: :typer)
  end

  test do
    output_log = testpath/"output.log"
    pid = spawn bin/"gruyere", "--details", [:out, :err] => output_log.to_s
    sleep 2
    sleep 4 if OS.mac? && Hardware::CPU.intel?
    assert_match "Here's what's running...", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
