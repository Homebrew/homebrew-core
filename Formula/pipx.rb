class Pipx < Formula
  desc "Execute binaries from Python packages in isolated environments"
  homepage "https://github.com/pipxproject/pipx"
  url "https://files.pythonhosted.org/packages/0a/8e/47ba7773d5ac5257465ec036b648a8afcd5c91f22b9f884812ecd4774b35/pipx-0.15.5.1.tar.gz"
  sha256 "7b1060504b8089a932c40d41002319967ffeefd0b60bc8f0499d0d290110ae80"
  license "MIT"
  head "https://github.com/pipxproject/pipx.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "06464e5ef247436cba27fcf61bc100325cd758a1474dc4a362ee3c4197ea8268" => :catalina
    sha256 "f22bd7f92147733c026e06ea5f9de69d6890fa970c336f4a383189278af4f93f" => :mojave
    sha256 "6d5a8cc7ac5c94a6892badae0085a4e7a02f26662ec8f9251afad256472c4b6d" => :high_sierra
  end

  depends_on "python@3.8"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/df/a0/3544d453e6b80792452d71fdf45aac532daf1c2b2d7fc6cb712e1c3daf11/argcomplete-1.12.0.tar.gz"
    sha256 "2fbe5ed09fd2c1d727d4199feca96569a5b50d44c71b16da9c742201f7cc295c"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/55/fd/fc1aca9cf51ed2f2c11748fa797370027babd82f87829c7a8e6dbe720145/packaging-20.4.tar.gz"
    sha256 "4357f74f47b9c12db93624a82154e9b120fa8293699949152b22065d556079f8"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "userpath" do
    url "https://files.pythonhosted.org/packages/86/2b/0a443e7978ea0f6bc1baece1de35545fa12f6d9fc5451aa90529db41db70/userpath-1.4.1.tar.gz"
    sha256 "211544ea02d8715fdc06f429cf66cd18c9877a31751d966d6de11b24faaed255"
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
    assert_true FileTest.exist?("#{testpath}/.local/bin/csvjoin")
    system "#{bin}/pipx", "uninstall", "csvkit"
    assert_no_match Regexp.new("csvjoin"), shell_output("#{bin}/pipx list")
  end
end
