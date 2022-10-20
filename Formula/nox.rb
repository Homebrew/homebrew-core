class Nox < Formula
  include Language::Python::Virtualenv

  desc "Flexible test automation for Python"
  homepage "https://nox.thea.codes/"
  url "https://files.pythonhosted.org/packages/12/f1/a810cf1f56e47b990824ebbb19e789745e4d1ea80ac0f2b6494c50e3f6a5/nox-2022.8.7.tar.gz"
  sha256 "1b894940551dc5c389f9271d197ca5d655d40bdc6ccf93ed6880e4042760a34b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "524a00fdd2e3cd7a73481cc4a3218584bb3f87b3e998fd1f8e213efcd0b727b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23fad278d8f1b41cb65be4233ee6e42b464b22355bf544cb0d634ff822d56cc1"
    sha256 cellar: :any_skip_relocation, monterey:       "ef9c0fee4b50f5b3fb69319fd7e41a159ba05df1da023d5803bb6339cb1d30a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "78f3a23e40aeacec806e4d0ca73409b01f15b56f80c83df4353ee8b40c5e6a91"
    sha256 cellar: :any_skip_relocation, catalina:       "a4227174435897a6d177b3217533b65de08465eac036cc1af2cb6c650a1dd86a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d81578444a1d7a788fd53a8b295e8439671b8857e3a036e72237e0a95189b32"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/05/f8/67851ae4fe5396ba6868c5d84219b81ea6a5d53991a6853616095c30adc0/argcomplete-2.0.0.tar.gz"
    sha256 "6372ad78c89d662035101418ae253668445b391755cfe94ea52f1b9d22425b20"
  end

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/8e/8f/1537ebed273d43edd3bb21f1e5861549b7cfcb1d47523d7277cab988cec2/colorlog-6.6.0.tar.gz"
    sha256 "344f73204009e4c83c5b6beb00b3c45dc70fcdae3c80db919e0a4171d006fde8"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/31/d5/e2aa0aa3918c8d88c4c8e4ebbc50a840e101474b98cd83d3c1712ffe5bb4/distlib-0.3.5.tar.gz"
    sha256 "a7f75737c70be3b25e2bee06288cec4e4c221de18455b2dd037fe2a795cab2fe"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/f3/c7/5c1aef87f1197d2134a096c0264890969213c9cbfb8a4102087e8d758b5c/filelock-3.7.1.tar.gz"
    sha256 "3a0fd85166ad9dbab54c9aec96737b744106dc5f15c0b09a6744a445299fcf04"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/ff/7b/3613df51e6afbf2306fc2465671c03390229b55e3ef3ab9dd3f846a53be6/platformdirs-2.5.2.tar.gz"
    sha256 "58c8abb07dcb441e6ee4b11d8df0ac856038f944ab98b7be6b27b2a3c7feef19"
  end

  resource "py" do
    url "https://files.pythonhosted.org/packages/98/ff/fec109ceb715d2a6b4c4a85a61af3b40c723a961e8828319fbcb15b868dc/py-1.11.0.tar.gz"
    sha256 "51c75c4126074b472f746a24399ad32f6053d1b34b68d2fa41e558e6f4a98719"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/3c/ea/a39a173e7943a8f001e1f97326f88e1535b945a3aec31130c3029dce19df/virtualenv-20.16.3.tar.gz"
    sha256 "d86ea0bb50e06252d79e6c241507cb904fcd66090c3271381372d6221a3970f9"
  end

  def install
    virtualenv_install_with_resources
    (bin/"tox-to-nox").unlink
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    (testpath/"noxfile.py").write <<~EOS
      import nox

      @nox.session
      def tests(session):
          session.install("pytest")
          session.run("pytest")
    EOS
    (testpath/"test_trivial.py").write <<~EOS
      def test_trivial():
          assert True
    EOS
    assert_match "usage", shell_output("#{bin}/nox --help")
    assert_match "1 passed", shell_output("#{bin}/nox")
  end
end
