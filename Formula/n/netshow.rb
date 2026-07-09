class Netshow < Formula
  include Language::Python::Virtualenv

  desc "Interactive network connection monitor with friendly service names"
  homepage "https://github.com/taylorwilsdon/netshow"
  url "https://files.pythonhosted.org/packages/2b/dc/7dde1dd71210311e124155309b38b209e0e81c631422e58c762821b37b61/netshow-0.2.2.tar.gz"
  sha256 "c3a684d186463033b99df13d2408669d779cbd8051f031a45fab6380dd34a1e7"
  license "MIT"
  revision 1
  head "https://github.com/taylorwilsdon/netshow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c19197cfda0a864cc73f3087f4d79051beeb024ebed3900d20ccadb22fc10114"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e56ee6c4dce9911931a31077e3ba125a4788ff6802717ce025badd165fcbf9bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84e27dac8459026acceedbb031c99f28064d7e648dd253280faa8f0c43f9496e"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad8cf47828851f33b628bb330602f72b575d49cd23511ff38d4daf9ec817e353"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aaaf002e96270f89bbfdd38cb3ebdf0d27c37e42054b18f332dfb981bc6b94b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "964965e3bd8ca444a2a708839104c98b56f37813cc7c4e0424afe52850a5cc16"
  end

  depends_on "python@3.14"

  resource "linkify-it-py" do
    url "https://files.pythonhosted.org/packages/2e/c9/06ea13676ef354f0af6169587ae292d3e2406e212876a413bf9eece4eb23/linkify_it_py-2.1.0.tar.gz"
    sha256 "43360231720999c10e9328dc3691160e27a718e280673d444c38d7d3aaa3b98b"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdit-py-plugins" do
    url "https://files.pythonhosted.org/packages/b2/fd/a756d36c0bfba5f6e39a1cdbdbfdd448dc02692467d83816dff4592a1ebc/mdit_py_plugins-0.5.0.tar.gz"
    sha256 "f4918cb50119f50446560513a8e311d574ff6aaed72606ddae6d35716fe809c6"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/19/56/8d4c30c8a1d07013911a8fdbd8f89440ef9f08d07a1b50ab8ca8be5a20f9/platformdirs-4.9.4.tar.gz"
    sha256 "1ec356301b7dc906d83f371c8f487070e99d3ccf9e501686456394622a01a934"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b3/c6/f3b320c27991c46f43ee9d856302c70dc2d0fb2dba4842ff739d5f46b393/rich-14.3.3.tar.gz"
    sha256 "b8daa0b9e4eef54dd8cf7c86c03713f53241884e814f4e2f5fb342fe520f639b"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/4f/07/766ad19cf2b15cae2d79e0db46a1b783b62316e9ff3e058e7424b2a4398b/textual-8.2.1.tar.gz"
    sha256 "4176890e9cd5c95dcdd206541b2956b0808e74c8c36381c88db53dcb45237451"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "uc-micro-py" do
    url "https://files.pythonhosted.org/packages/78/67/9a363818028526e2d4579334460df777115bdec1bb77c08f9db88f6389f2/uc_micro_py-2.0.0.tar.gz"
    sha256 "c53691e495c8db60e16ffc4861a35469b0ba0821fe409a8a7a0a71864d33a811"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output_log = testpath/"output.log"
    pid = spawn bin/"netshow", [:out, :err] => output_log.to_s
    sleep 3
    sleep 12 if OS.mac? && Hardware::CPU.intel?
    assert_match "Netshow (lsof)", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
