class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://github.com/pypa/pipenv"
  url "https://files.pythonhosted.org/packages/5f/bc/779ccbc80b2cf29320ae49dbfc5deb2ed154c727ce5da3581d257e71abef/pipenv-2022.9.21.tar.gz"
  sha256 "65ecfb395fdf7d76a28b212a86bdb1de68e406109ed3c39d6e6d72bfd7838fed"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8cd831815021ee803ad2129ab250b5e4eea6016dfdd8ac141743fbe27bb3daec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "83d149455c0c3f08a1b7f49388d652ca9d3f04a09db3f896e3e72d6fc475572e"
    sha256 cellar: :any_skip_relocation, monterey:       "699d01bf268d9a90ba592ac090569f1f0daebb3f0fb61f59fed17504c7b28d1a"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b6ae4df63408d105740008bed9180ea3071df1c3ced744df97e616d87a02762"
    sha256 cellar: :any_skip_relocation, catalina:       "13d866aa06ccfaa0dd56096bacd18dce07de31cbe5734a791fff2be8e867166d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec6c6ba55bf78e49cb7571b29648237afc9d6f74de24e89bcf619ddcff337f42"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/ca/48/88ec470f8b68319b6782ca3a0570789886ad5ca24c1af2f3771699135baa/certifi-2022.9.14.tar.gz"
    sha256 "36973885b9542e6bd01dea287b2b4b3b21236307c56324fcc3f1160f2d655ed5"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/58/07/815476ae605bcc5f95c87a62b95e74a1bce0878bc7a3119bc2bf4178f175/distlib-0.3.6.tar.gz"
    sha256 "14bad2d9b04d3a36127ac97f30b12a19268f211063d8f8ee4f47108896e11b46"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/95/55/b897882bffb8213456363e646bf9e9fa704ffda5a7d140edf935a9e02c7b/filelock-3.8.0.tar.gz"
    sha256 "55447caa666f2198c5b6b13a26d2084d26fa5b115c00d065664b2124680c4edc"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/ff/7b/3613df51e6afbf2306fc2465671c03390229b55e3ef3ab9dd3f846a53be6/platformdirs-2.5.2.tar.gz"
    sha256 "58c8abb07dcb441e6ee4b11d8df0ac856038f944ab98b7be6b27b2a3c7feef19"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/07/a3/bd699eccc596c3612c67b06772c3557fda69815972eef4b22943d7535c68/virtualenv-20.16.5.tar.gz"
    sha256 "227ea1b9994fdc5ea31977ba3383ef296d7472ea85be9d6732e42a91c04e80da"
  end

  resource "virtualenv-clone" do
    url "https://files.pythonhosted.org/packages/85/76/49120db3bb8de4073ac199a08dc7f11255af8968e1e14038aee95043fafa/virtualenv-clone-0.5.7.tar.gz"
    sha256 "418ee935c36152f8f153c79824bb93eaf6f0f7984bae31d3f48f350b9183501a"
  end

  def python3
    "python3.10"
  end

  def install
    # Using the virtualenv DSL here because the alternative of using
    # write_env_script to set a PYTHONPATH breaks things.
    # https://github.com/Homebrew/homebrew-core/pull/19060#issuecomment-338397417
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources
    venv.pip_install buildpath

    # `pipenv` needs to be able to find `virtualenv` on PATH. So we
    # install symlinks for those scripts in `#{libexec}/tools` and create a
    # wrapper script for `pipenv` which adds `#{libexec}/tools` to PATH.
    (libexec/"tools").install_symlink libexec/"bin/pip", libexec/"bin/virtualenv"
    env = {
      PATH: "#{libexec}/tools:$PATH",
    }
    (bin/"pipenv").write_env_script(libexec/"bin/pipenv", env)

    (zsh_completion/"_pipenv").write Utils.safe_popen_read({ "_PIPENV_COMPLETE" => "zsh_source" },
                                                           libexec/"bin/pipenv", { err: :err })
    (fish_completion/"pipenv.fish").write Utils.safe_popen_read({ "_PIPENV_COMPLETE" => "fish_source" },
                                                                libexec/"bin/pipenv", { err: :err })
  end

  # Avoid relative paths
  def post_install
    lib_python_path = Pathname.glob(libexec/"lib/python*").first
    lib_python_path.each_child do |f|
      next unless f.symlink?

      realpath = f.realpath
      rm f
      ln_s realpath, f
    end
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    assert_match "Commands", shell_output("#{bin}/pipenv")
    system "#{bin}/pipenv", "--python", which(python3)
    system "#{bin}/pipenv", "install", "requests"
    system "#{bin}/pipenv", "install", "boto3"
    assert_predicate testpath/"Pipfile", :exist?
    assert_predicate testpath/"Pipfile.lock", :exist?
    assert_match "requests", (testpath/"Pipfile").read
    assert_match "boto3", (testpath/"Pipfile").read
  end
end
