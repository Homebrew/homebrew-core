class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "https://pre-commit.com/"
  url "https://files.pythonhosted.org/packages/32/ea/13bb25c70e6d04b5788c42e0d3fcc82b06bc89f5d44c3c5606ef1af5a7cc/pre_commit-2.17.0.tar.gz"
  sha256 "c1a8040ff15ad3d648c70cc3e55b93e4d2d5b687320955505587fd79bbaed06a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "07ffa958d22e4403ee60712078bab21f0028e8fc416325c1afc3afed9f2943c5"
    sha256 cellar: :any,                 arm64_big_sur:  "9e128b63df515aacbeb2c78b059a3facf11085a1fc719b1d87f7c9a8fe29fa1c"
    sha256 cellar: :any,                 monterey:       "e97e72cb89768de9ef0ad26ff07d05171d96b8b4efcd54161b2a1041dbe96844"
    sha256 cellar: :any,                 big_sur:        "a0405e5b9df23b4db7b213931cdacb291c076706c8b6fb8ed4027e6b7cf02fde"
    sha256 cellar: :any,                 catalina:       "c865ca0e17e8a20fec61601cfbe73ee2e13ef53a09aaffcb9937456d2847b4a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76a7a62b1b5c5e7bcd5a68ad5738956281e9f7977b5f07b97293f5cb6608e02a"
  end

  depends_on "libyaml"
  depends_on "python@3.10"
  depends_on "six"

  resource "cfgv" do
    url "https://files.pythonhosted.org/packages/c4/bf/d0d622b660d414a47dc7f0d303791a627663f554345b21250e39e7acb48b/cfgv-3.3.1.tar.gz"
    sha256 "f5a830efb9ce7a445376bb66ec94c638a9787422f96264c98edc6bdeed8ab736"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/85/01/88529c93e41607f1a78c1e4b346b24c74ee43d2f41cfe33ecd2e20e0c7e3/distlib-0.3.4.zip"
    sha256 "e4b58818180336dc9c529bfb9a0b58728ffc09ad92027a3f30b7cd91e3458579"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/11/d1/22318a1b5bb06c9be4c065ad6a09cb7bfade737758dc08235c99cd6cf216/filelock-3.4.2.tar.gz"
    sha256 "38b4f4c989f9d06d44524df1b24bd19e167d851f19b50bf3e3559952dddc5b80"
  end

  resource "identify" do
    url "https://files.pythonhosted.org/packages/82/c7/750d9467e90be6c8c8ff94a7aff029ed1229f2d53843ddf8d2b142051c88/identify-2.4.4.tar.gz"
    sha256 "6b4b5031f69c48bf93a646b90de9b381c6b5f560df4cbe0ed3cf7650ae741e4d"
  end

  resource "nodeenv" do
    url "https://files.pythonhosted.org/packages/75/8d/14c4ac588711f8de0dd02a11460ed72f48cab65a998994ca20f40c6e1a8f/nodeenv-1.6.0.tar.gz"
    sha256 "3ef13ff90291ba2a4a7a4ff9a979b63ffdd00a464dbe04acf0ea6471517a4c2b"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/be/00/bd080024010e1652de653bd61181e2dfdbef5fa73bfd32fec4c808991c31/platformdirs-2.4.1.tar.gz"
    sha256 "440633ddfebcc36264232365d7840a970e75e1018d15b4327d11f91909045fda"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/f1/db/4498de0294f0c72a2e0a099d1588e7b55d0c849db740c89978ff73700519/virtualenv-20.13.0.tar.gz"
    sha256 "d8458cf8d59d0ea495ad9b34c2599487f8a7772d796f9910858376d1600dd2dd"
  end

  def install
    # Avoid Cellar path reference, which is only good for one version.
    inreplace "pre_commit/commands/install_uninstall.py",
              "f'INSTALL_PYTHON={shlex.quote(sys.executable)}\\n'",
              "f'INSTALL_PYTHON={shlex.quote(\"#{opt_libexec}/bin/python3\")}\\n'"

    virtualenv_install_with_resources
  end

  # Avoid relative paths
  def post_install
    xy = Language::Python.major_minor_version Formula["python@3.10"].opt_bin/"python3"
    dirs_to_fix = [libexec/"lib/python#{xy}"]
    dirs_to_fix << (libexec/"bin") if OS.linux?
    dirs_to_fix.each do |folder|
      folder.each_child do |f|
        next unless f.symlink?

        realpath = f.realpath
        rm f
        ln_s realpath, f
      end
    end
  end

  test do
    system "git", "init"
    (testpath/".pre-commit-config.yaml").write <<~EOS
      -   repo: https://github.com/pre-commit/pre-commit-hooks
          sha: v0.9.1
          hooks:
          -   id: trailing-whitespace
    EOS
    system bin/"pre-commit", "install"
    (testpath/"f").write "hi\n"
    system "git", "add", "f"

    ENV["GIT_AUTHOR_NAME"] = "test user"
    ENV["GIT_AUTHOR_EMAIL"] = "test@example.com"
    ENV["GIT_COMMITTER_NAME"] = "test user"
    ENV["GIT_COMMITTER_EMAIL"] = "test@example.com"
    git_exe = which("git")
    ENV["PATH"] = "/usr/bin:/bin"
    system git_exe, "commit", "-m", "test"
  end
end
