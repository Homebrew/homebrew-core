class Netshow < Formula
  include Language::Python::Virtualenv

  desc "Interactive network connection monitor with friendly service names"
  homepage "https://github.com/taylorwilsdon/netshow"
  url "https://files.pythonhosted.org/packages/7f/81/fc97b3c70ecdd747583c1016373a64bb0e8b7519ed02fd234eaaf527a756/netshow-0.3.0.tar.gz"
  sha256 "9641bf5a6512615c5faa09d4077756a0e8dfd97a7b202b960e4ac1f04f5f8c8c"
  license "MIT"
  head "https://github.com/taylorwilsdon/netshow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fa0e5a5368cefe90e16c40d4ea3f3d7d3e27675b49743fed5523b8ff2018f9b5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f263f859f94b773b607fcce2835e91a41010a7e08b30e331bf38a9b7b2642183"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5b40453e1b9694f045b8bdaceba70ac7cb4a7d993a10e2dffe0212d973c6a32b"
    sha256 cellar: :any,                 arm64_linux:       "294a8b3bdb565bc09f92f16d61b2a2f82d4644b59f7ac2643cc1b12f1883d1e3"
    sha256 cellar: :any,                 x86_64_linux:      "dea578f1d76356612454476ebff2a7e3f1fe5ed4067fe2e3f15efabac2005a0f"
  end

  depends_on "python@3.14"

  resource "linkify-it-py" do
    url "https://files.pythonhosted.org/packages/45/98/7a1a5f31fd5c7ba93e963b168e244b8e3dd705b3d2a718e3c3307583bf57/linkify_it_py-2.2.0.tar.gz"
    sha256 "907acd2d17ac1fbb9ddb62c8957ccbd6158cac602231a15c3b0cd1e215f03cee"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdit-py-plugins" do
    url "https://files.pythonhosted.org/packages/59/fc/f8d0863f8862f25602c0404d75568e89fb6b4109804645e5cdfb1be5cf56/mdit_py_plugins-0.6.1.tar.gz"
    sha256 "a2bca0f039f39dbd35fb74ae1b5f998608c437463371f0ff7f49a19a17a114d0"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/f8/13/f870dd0b42690138e4e37a76b5138e5690ed4365a77071bb092d59037da0/platformdirs-4.11.11.tar.gz"
    sha256 "b0befe8a90759e4a9a8b9820d434ae226a6549063210b596da0038a7a05aede4"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/e9/67/cae617f1351490c25a4b8ac3b8b63a4dda609295d8222bad12242dfdc629/rich-14.3.4.tar.gz"
    sha256 "817e02727f2b25b40ef56f5aa2217f400c8489f79ca8f46ea2b70dd5e14558a9"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/00/21/39a76b01bd5eea82a04baaca7580e105d8c59450df03998345bb2cfb307b/textual-8.2.8.tar.gz"
    sha256 "3f106a9fbc73e39dd266c9712432087de78a6d644084c7c241d6a25c3169115b"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    require "expect"
    require "pty"
    require "io/console"

    PTY.spawn(bin/"netshow") do |r, w, _pid|
      r.winsize = [24, 80]
      r.set_encoding("UTF-8")
      refute_nil r.expect("Netshow", 30), "expected the netshow title"
      w.write "q"
      r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  end
end
