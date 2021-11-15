class Pipx < Formula
  desc "Execute binaries from Python packages in isolated environments"
  homepage "https://github.com/pypa/pipx"
  url "https://files.pythonhosted.org/packages/8c/38/b9cbadcccc01be38f7fd47e52acc623657a0ecfc51eb43129c3825efc84c/pipx-0.16.4.tar.gz"
  sha256 "992e78082c0b33c7bc708176ce9e0df9bac9ae3b08bf111c368571bc32e723d6"
  license "MIT"
  revision 2
  head "https://github.com/pypa/pipx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "368679de313c91bb95ae0b618cee93b2cccf0f9f8d6a969f98165d8a7c4fa8cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "368679de313c91bb95ae0b618cee93b2cccf0f9f8d6a969f98165d8a7c4fa8cf"
    sha256 cellar: :any_skip_relocation, monterey:       "b310cf1250d3dc6b002bd4f709015105ccc593a57aee1aa2b79cb308ac6f6214"
    sha256 cellar: :any_skip_relocation, big_sur:        "b310cf1250d3dc6b002bd4f709015105ccc593a57aee1aa2b79cb308ac6f6214"
    sha256 cellar: :any_skip_relocation, catalina:       "b310cf1250d3dc6b002bd4f709015105ccc593a57aee1aa2b79cb308ac6f6214"
    sha256 cellar: :any_skip_relocation, mojave:         "b310cf1250d3dc6b002bd4f709015105ccc593a57aee1aa2b79cb308ac6f6214"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "469a03613a40a9ea0d30ea0779274f7abab1270297111522bbb7cbb0b2a4c8d1"
  end

  depends_on "python@3.10"

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
      url "https://files.pythonhosted.org/packages/a5/26/256fa167fe1bf8b97130b4609464be20331af8a3af190fb636a8a7efd7a2/distro-1.6.0.tar.gz"
      sha256 "83f5e5a09f9c5f68f60173de572930effbcc0287bb84fdc4426cb4168c088424"
    end
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/86/aef78bab3afd461faecf9955a6501c4999933a48394e90f03cd512aad844/packaging-21.0.tar.gz"
    sha256 "7dc96269f53a4ccec5c0670940a4281106dd0bb343f47b7471f779df49c2fbe7"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "userpath" do
    url "https://files.pythonhosted.org/packages/60/2c/0620bacd069a14a601b0a5ba4578b223fa6ae34b9dd97e5508798b7f3dee/userpath-1.7.0.tar.gz"
    sha256 "dcd66c5fa9b1a3c12362f309bbb5bc7992bac8af86d17b4e6b1a4b166a11c43f"
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
