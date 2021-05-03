class Pipx < Formula
  desc "Execute binaries from Python packages in isolated environments"
  homepage "https://github.com/pipxproject/pipx"
  url "https://files.pythonhosted.org/packages/92/09/c4afd1d89677871c3a69657b9aa34c12328b2fb409b068e3933a6e8c2fa4/pipx-0.16.2.1.tar.gz"
  sha256 "805319eab100c0c36e349b76103bbe903445229a60ebb0010d7cf7590ff5ba20"
  license "MIT"
  head "https://github.com/pipxproject/pipx.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a6dde65154b456011d4157a3dded90f118266af5f1447a1601044d219706e164"
    sha256 cellar: :any_skip_relocation, big_sur:       "61219c287997023648711a74f6a88ed74cc8696a5a8cdca4db23ab9c4c0c51cb"
    sha256 cellar: :any_skip_relocation, catalina:      "61219c287997023648711a74f6a88ed74cc8696a5a8cdca4db23ab9c4c0c51cb"
    sha256 cellar: :any_skip_relocation, mojave:        "61219c287997023648711a74f6a88ed74cc8696a5a8cdca4db23ab9c4c0c51cb"
  end

  depends_on "python@3.9"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/6a/b4/3b1d48b61be122c95f4a770b2f42fc2552857616feba4d51f34611bd1352/argcomplete-1.12.3.tar.gz"
    sha256 "2c7dbffd8c045ea534921e63b0be6fe65e88599990d8dc408ac8c542b72a5445"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "distro" do
    on_linux do
      url "https://files.pythonhosted.org/packages/a6/a4/75064c334d8ae433445a20816b788700db1651f21bdb0af33db2aab142fe/distro-1.5.0.tar.gz"
      sha256 "0e58756ae38fbd8fc3020d54badb8eae17c5b9dcbed388b17bb55b8a5928df92"
    end
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
    refute_match "csvjoin", shell_output("#{bin}/pipx list")
  end
end
