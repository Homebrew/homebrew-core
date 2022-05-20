class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "https://pre-commit.com/"
  url "https://files.pythonhosted.org/packages/d0/3c/f0906f9e015c2fd38ca912cb9a6d2eb10c6ca0ce0fd318239993466613b7/pre_commit-2.19.0.tar.gz"
  sha256 "4233a1e38621c87d9dda9808c6606d7e7ba0e087cd56d3fe03202a01d2919615"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "35830ae8dc83700b547c078a43e0cae5b99c69d820e6a70b7dd43872105cc075"
    sha256 cellar: :any,                 arm64_big_sur:  "ae925eb818c247559e36558216c63a5298653d65ecd528383340a0ee8b92c07e"
    sha256 cellar: :any,                 monterey:       "fa8795f2fc5231708ac69b3447732d3342ac77084c75d4cd92636e4cb3306918"
    sha256 cellar: :any,                 big_sur:        "1eb31671ec49ce4703bdf821c46238a541ef5972f462174f4765dac8a2cf72c3"
    sha256 cellar: :any,                 catalina:       "4852270ec8f9249be28101899cfc2f5718b8b5ac79432089484af3e754a075cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6376d63fa6a158bd89dcf23bf75c6b684c542ca933c4c47e434287f92649cd17"
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
    url "https://files.pythonhosted.org/packages/4d/cd/3b1244a19d61c4cf5bd65966eef97e6bc41e51fe84110916f26554d6ac8c/filelock-3.6.0.tar.gz"
    sha256 "9cd540a9352e432c7246a48fe4e8712b10acb1df2ad1f30e8c070b82ae1fed85"
  end

  resource "identify" do
    url "https://files.pythonhosted.org/packages/e7/de/5c84c44cf63f89418927c206da12008287767fe57c95f901f47300dd17f8/identify-2.5.0.tar.gz"
    sha256 "c83af514ea50bf2be2c4a3f2fb349442b59dc87284558ae9ff54191bff3541d2"
  end

  resource "nodeenv" do
    url "https://files.pythonhosted.org/packages/75/8d/14c4ac588711f8de0dd02a11460ed72f48cab65a998994ca20f40c6e1a8f/nodeenv-1.6.0.tar.gz"
    sha256 "3ef13ff90291ba2a4a7a4ff9a979b63ffdd00a464dbe04acf0ea6471517a4c2b"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/ff/7b/3613df51e6afbf2306fc2465671c03390229b55e3ef3ab9dd3f846a53be6/platformdirs-2.5.2.tar.gz"
    sha256 "58c8abb07dcb441e6ee4b11d8df0ac856038f944ab98b7be6b27b2a3c7feef19"
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
    url "https://files.pythonhosted.org/packages/5f/6c/d44c403a54ceb4ec5179d1a963c69887d30dc5b300529ce67c05b4f16212/virtualenv-20.14.1.tar.gz"
    sha256 "ef589a79795589aada0c1c5b319486797c03b67ac3984c48c669c0e4f50df3a5"
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
