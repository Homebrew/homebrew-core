class Pipx < Formula
  desc "Execute binaries from Python packages in isolated environments"
  homepage "https://github.com/pipxproject/pipx"
  url "https://files.pythonhosted.org/packages/c3/9e/5d93d784225a36c36d8be09144eea0a73f9f85385dfa02881c51644495be/pipx-0.15.4.0.tar.gz"
  sha256 "b90285a1c6eddf45ba4e48110b81d7c1e285b127e82fa99a61168937f98e5cb5"
  license "MIT"
  head "https://github.com/pipxproject/pipx.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9d3b8ecd4650b1877c489951f774c1a5eedcb289497cbf9d8b3102d1d71322c6" => :catalina
    sha256 "9d3b8ecd4650b1877c489951f774c1a5eedcb289497cbf9d8b3102d1d71322c6" => :mojave
    sha256 "9d3b8ecd4650b1877c489951f774c1a5eedcb289497cbf9d8b3102d1d71322c6" => :high_sierra
  end

  depends_on "python@3.8"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/43/61/345856864a72ccc004bea5f74183c58bfd6675f9eab931ff9ce21a8fe06b/argcomplete-1.11.1.tar.gz"
    sha256 "5ae7b601be17bf38a749ec06aa07fb04e7b6b5fc17906948dc1866e7facf3740"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "userpath" do
    url "https://files.pythonhosted.org/packages/09/3a/e8b02ae27ce44a3773a5d7a7fd52c78531ade5c902123694e86a1fa0e909/userpath-1.4.0.tar.gz"
    sha256 "8f555126f137c08c576f73e6a9d7089ee394e9ba00a53a75c37f05439ca3cf51"
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
