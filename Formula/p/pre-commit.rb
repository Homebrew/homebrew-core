class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "https://pre-commit.com/"
  url "https://files.pythonhosted.org/packages/3a/c3/6965c2690ddce885ec75121572d065a5b94c5a5d8d3e657927ecda9fd715/pre_commit-4.7.0.tar.gz"
  sha256 "1f3deee12b914c8fa184bd2b5953391c2e4f36763e403d4a23dc9983fa7c6e86"
  license "MIT"
  revision 2
  head "https://github.com/pre-commit/pre-commit.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "67c99a5603bb473b5803d43e78c58ca618311f1a16a41d34d1662e9547a8b846"
    sha256 cellar: :any, arm64_tahoe:       "b23f6c0a81af6944d672f8263a361da002b3a72b96f3718049d92bf4888a0a0a"
    sha256 cellar: :any, arm64_sequoia:     "937e49297cfbe445437090291b5f917a8e86aa6004855c6a69161d90704d4102"
    sha256 cellar: :any, arm64_linux:       "7dce83cea30762d18b66c70798fabbc2c58fc0669d6b6329ad9309bae96e7de9"
    sha256 cellar: :any, x86_64_linux:      "34a55f418c50e1f2d0732af2e64c2c95b7bf5b598ba880bf5f99fef791a7e1dd"
  end

  depends_on "libyaml"
  depends_on "python@3.15"

  resource "cfgv" do
    url "https://files.pythonhosted.org/packages/4e/b5/721b8799b04bf9afe054a3899c6cf4e880fcf8563cc71c15610242490a0c/cfgv-3.5.0.tar.gz"
    sha256 "d5b1034354820651caa73ede66a6294d6e95c1b00acc5e9b098e917404669132"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/68/bc/d36966de7304047a1001a7559fbf266c464bb5d8cc85464536ef8c9bcc32/distlib-0.4.4.tar.gz"
    sha256 "ca4175b4ac7f71223cc30ed7248c45d2b38c2439d8ee6e498ab67ed63cf3508d"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/d8/28/3893324bcadf8f89b1616637468d766af3f625008c0735bf704fdfa86617/filelock-4.2.4.tar.gz"
    sha256 "c6d8663535e1650ee430507b4ffbac7b464dd64b7647ea0112a9f406499d163d"
  end

  resource "identify" do
    url "https://files.pythonhosted.org/packages/53/35/d70c0006c7cee65999ea94a6273e60b2094f600a3d8b71b04318253fc643/identify-2.6.20.tar.gz"
    sha256 "ad729860a923858d26917c2f4fb0a1d83d27a75b1e090c06440c573f048f3285"
  end

  resource "nodeenv" do
    url "https://files.pythonhosted.org/packages/9a/8e/105de02c1322cfada6d9710d9146ef8026419d433c9d08359a2d35805811/nodeenv-1.11.0.tar.gz"
    sha256 "3ce8fe5b71d16e8af7039ca65257354100bc772965d6bc549070649e53b1b146"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/58/e6/d0abbb256b44e6a05748c6942511ff67db8dbb068de0c35b24bf1b395b09/platformdirs-4.13.5.tar.gz"
    sha256 "05831adf87d392760f4b5c3a0a95579ab5a10b18b9b9bd43680dcb47544788a0"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/f3/ee/cf608372c88ce2c136ee13c69ab6f667dbc0d0c1176af188b4ddc8853e66/python_discovery-1.6.4.tar.gz"
    sha256 "bc70d31f0ec5de11eda13d4d64c16e24b3506a65984684f2b6c98cb83b2ea9df"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/70/aa/bff50daee0488e16d611258a9b6c5a1d0c9e128f8ca424e9f4e1c0444ef2/virtualenv-21.14.13.tar.gz"
    sha256 "de5307ba4b9a0001d9c8ea02832d38f63ca432880f416c1bface61c4323fd905"
  end

  def install
    # Avoid Cellar path reference, which is only good for one version.
    inreplace "pre_commit/commands/install_uninstall.py",
              "f'INSTALL_PYTHON={shlex.quote(sys.executable)}\\n'",
              "f'INSTALL_PYTHON={shlex.quote(\"#{opt_libexec}/bin/#{python3.basename}\")}\\n'"

    virtualenv_install_with_resources
  end

  test do
    system "git", "init"
    (testpath/".pre-commit-config.yaml").write <<~YAML
      repos:
      -   repo: https://github.com/pre-commit/pre-commit-hooks
          rev: v0.9.1
          hooks:
          -   id: trailing-whitespace
    YAML
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
