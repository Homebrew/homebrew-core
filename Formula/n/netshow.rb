class Netshow < Formula
  include Language::Python::Virtualenv

  desc "Interactive network connection monitor with friendly service names"
  homepage "https://github.com/taylorwilsdon/netshow"
  url "https://files.pythonhosted.org/packages/2b/dc/7dde1dd71210311e124155309b38b209e0e81c631422e58c762821b37b61/netshow-0.2.2.tar.gz"
  sha256 "c3a684d186463033b99df13d2408669d779cbd8051f031a45fab6380dd34a1e7"
  license "MIT"
  head "https://github.com/taylorwilsdon/netshow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14d3f73a7dbf0e2710565ea3c9883f909e1ac9c021ada41808e9199f23f2978c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de36e5242f711026f8c45aaceba1b4e41e57f38af71aa26fc7573dcc348f4b2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ecf40e9e5ac626a38f8ba5dfeda403b8988998eae8fa2e8a7faa078b2f6011f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7f93ee1862d0f03384721eaad95c3bf62c38a311e146971213f7dd51489092c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3cbb279105577e092dfaa9704618dffb82903f4de82c6e66a13109dff9f683ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fcb9ec898607312887cea9891cd4de7192ebe8db7f1c5dd2b049b1a1cca1d10"
  end

  depends_on "python@3.14"

  resource "linkify-it-py" do
    url "https://files.pythonhosted.org/packages/2a/ae/bb56c6828e4797ba5a4821eec7c43b8bf40f69cda4d4f5f8c8a2810ec96a/linkify-it-py-2.0.3.tar.gz"
    sha256 "68cda27e162e9215c17d786649d1da0021a451bdc436ef9e0fa0ba5234b9b048"
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
    url "https://files.pythonhosted.org/packages/61/33/9611380c2bdb1225fdef633e2a9610622310fed35ab11dac9620972ee088/platformdirs-4.5.0.tar.gz"
    sha256 "70ddccdd7c99fc5942e9fc25636a8b34d04c24b335100223152c2803e4063312"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e1/88/bdd0a41e5857d5d703287598cbf08dad90aed56774ea52ae071bae9071b6/psutil-7.1.3.tar.gz"
    sha256 "6c86281738d77335af7aec228328e944b30930899ea760ecf33a4dba66be5e74"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/fb/d2/8920e102050a0de7bfabeb4c4614a49248cf8d5d7a8d01885fbb24dc767a/rich-14.2.0.tar.gz"
    sha256 "73ff50c7c0c1c77c8243079283f4edb376f0f6442433aecb8ce7e6d0b92d1fe4"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/f6/2f/f0b408f227edca21d1996c1cd0b65309f0cbff44264aa40aded3ff9ce2e1/textual-6.6.0.tar.gz"
    sha256 "53345166d6b0f9fd028ed0217d73b8f47c3a26679a18ba3b67616dcacb470eec"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "uc-micro-py" do
    url "https://files.pythonhosted.org/packages/91/7a/146a99696aee0609e3712f2b44c6274566bc368dfe8375191278045186b8/uc-micro-py-1.0.3.tar.gz"
    sha256 "d321b92cff673ec58027c04015fcaa8bb1e005478643ff4a500882eaab88c48a"
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
