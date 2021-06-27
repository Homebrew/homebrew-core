class Pipx < Formula
  desc "Execute binaries from Python packages in isolated environments"
  homepage "https://github.com/pypa/pipx"
  url "https://files.pythonhosted.org/packages/55/d2/7e4d2f0155ea58d818d043f76eb220ec4ac31df33adafaa7d7edf62b1aeb/pipx-0.16.3.tar.gz"
  sha256 "51fa41281383212db3b2a6906713871edc1a7d597ae387873026402e281a0b25"
  license "MIT"
  head "https://github.com/pypa/pipx.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3d2f7c5ed804dffb92b4d08a9f72f1581046df4c39492ab5742153843d7592cf"
    sha256 cellar: :any_skip_relocation, big_sur:       "65efd93e3f5b999df2d9b65774c71a3d0945e8b394a22623c110a274c283e714"
    sha256 cellar: :any_skip_relocation, catalina:      "65efd93e3f5b999df2d9b65774c71a3d0945e8b394a22623c110a274c283e714"
    sha256 cellar: :any_skip_relocation, mojave:        "65efd93e3f5b999df2d9b65774c71a3d0945e8b394a22623c110a274c283e714"
  end

  depends_on "python@3.9"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/6a/b4/3b1d48b61be122c95f4a770b2f42fc2552857616feba4d51f34611bd1352/argcomplete-1.12.3.tar.gz"
    sha256 "2c7dbffd8c045ea534921e63b0be6fe65e88599990d8dc408ac8c542b72a5445"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/21/83/308a74ca1104fe1e3197d31693a7a2db67c2d4e668f20f43a2fca491f9f7/click-8.0.1.tar.gz"
    sha256 "8c04c11192119b1ef78ea049e0a6f0463e4c48ef00a30160c704337586f3ad7a"
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
    url "https://files.pythonhosted.org/packages/54/ff/48ddc6562a06c38db208ba347512af3d366232333d30a91538f14335a8b9/userpath-1.6.0.tar.gz"
    sha256 "b2b9a5ca1478ecfa63514b48709d650f48bf7be89f62bd236db556b85b6deff6"
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

    # Install shell completions
    output = Utils.safe_popen_read(libexec/"bin/register-python-argcomplete", "--shell=bash", "pipx")
    (bash_completion/"pipx").write output

    output = Utils.safe_popen_read(libexec/"bin/register-python-argcomplete", "--shell=fish", "pipx")
    (fish_completion/"pipx.fish").write output
  end

  test do
    assert_match "PIPX_HOME", shell_output("#{bin}/pipx --help")
    system "#{bin}/pipx", "install", "csvkit"
    assert_predicate testpath/".local/bin/csvjoin", :exist?
    system "#{bin}/pipx", "uninstall", "csvkit"
    refute_match "csvjoin", shell_output("#{bin}/pipx list")
  end
end
