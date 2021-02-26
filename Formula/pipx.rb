class Pipx < Formula
  desc "Execute binaries from Python packages in isolated environments"
  homepage "https://github.com/pipxproject/pipx"
  url "https://files.pythonhosted.org/packages/34/19/e79e0a9836187e0b576da06859314887715c3adf4c6e2b4b4d5629f5a04f/pipx-0.16.1.0.tar.gz"
  sha256 "22b9a0f0536e6b4e7ae030d33cbe34528c3f7ad1615d0c3795f2e5ac4db9d76d"
  license "MIT"
  head "https://github.com/pipxproject/pipx.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bab02779c5da9216dbc21812e5786dce16e6c0f79457575fd78037ed96bd6cd0"
    sha256 cellar: :any_skip_relocation, big_sur:       "9c07a40553cfa635460d685e72ec0fc29192a0c50167d6c5ee8a441db3065453"
    sha256 cellar: :any_skip_relocation, catalina:      "abc0c5222a5ddafa0230be3df0e96251b10731ac139a776b367486fccf817ace"
    sha256 cellar: :any_skip_relocation, mojave:        "85019ec96f1cf0aa890a9424522755a3beb3a69d6ef508293cf9292895acd1b9"
  end

  depends_on "python@3.9"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/cb/53/d2e3d11726367351b00c8f078a96dacb7f57aef2aca0d3b6c437afc56b55/argcomplete-1.12.2.tar.gz"
    sha256 "de0e1282330940d52ea92a80fea2e4b9e0da1932aaa570f84d268939d1897b04"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/86/3c/bcd09ec5df7123abcf695009221a52f90438d877a2f1499453c6938f5728/packaging-20.9.tar.gz"
    sha256 "5b327ac1320dc863dca72f4514ecc086f31186744b84a230374cc1fd776feae5"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "userpath" do
    url "https://files.pythonhosted.org/packages/f0/1b/d2bccd0b855484e3b419c0d87990e6f588793fb7b233d8ea26fa620936fb/userpath-1.4.2.tar.gz"
    sha256 "dd4b5496e4ef2c1a3bbb103ffefa7738fa4ba15f23580918bb9f949dcd61a8a7"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"

    resources.each do |r|
      r.stage do
        system "python3", *Language::Python.setup_install_args(libexec)
      end
    end

    system "python3", *Language::Python.setup_install_args(libexec)
    (bin/"pipx").write_env_script(libexec/"bin/pipx", PYTHONPATH: ENV["PYTHONPATH"])
    (bin/"register-python-argcomplete").write_env_script(libexec/"bin/register-python-argcomplete",
      PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    assert_match "PIPX_HOME", shell_output("#{bin}/pipx --help")
    system "#{bin}/pipx", "install", "csvkit"
    assert_predicate testpath/".local/bin/csvjoin", :exist?
    system "#{bin}/pipx", "uninstall", "csvkit"
    assert_no_match Regexp.new("csvjoin"), shell_output("#{bin}/pipx list")
  end
end
