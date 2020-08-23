class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "https://pre-commit.com/"
  url "https://github.com/pre-commit/pre-commit/archive/v2.7.0.tar.gz"
  sha256 "b1eabb33382a0b00fa91b78cc1c0f6fe597b619e91b20aea2e31b94d0a64b482"
  license "MIT"

  bottle do
    cellar :any
    sha256 "07f783f5e5d2de8b0422862ff4d42ff640eacba5f5aee8f827a7420bafe1608d" => :catalina
    sha256 "81b50ee8b4627c98dd5fd5ce891db89fc4831fdee8402807c02699ec4b449c76" => :mojave
    sha256 "abec3b65eb9d7f5f6f7be12bbbbfe19d14bd5bfb0aeafd00c630b01aff8be317" => :high_sierra
  end

  depends_on "libyaml"
  depends_on "python@3.8"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "cfgv" do
    url "https://files.pythonhosted.org/packages/63/75/c80804e4a5eccc9acf767faf4591bb7ab289485ba236dfee542467dc7c9b/cfgv-3.2.0.tar.gz"
    sha256 "cf22deb93d4bcf92f345a5c3cd39d3d41d6340adc60c78bbbd6588c384fda6a1"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/2f/83/1eba07997b8ba58d92b3e51445d5bf36f9fba9cb8166bcae99b9c3464841/distlib-0.3.1.zip"
    sha256 "edf6116872c863e1aa9d5bb7cb5e05a022c519a4594dc703843343a9ddd9bff1"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/14/ec/6ee2168387ce0154632f856d5cc5592328e9cf93127c5c9aeca92c8c16cb/filelock-3.0.12.tar.gz"
    sha256 "18d82244ee114f543149c66a6e0c14e9c4f8a1044b5cdaadd0f82159d6a6ff59"
  end

  resource "identify" do
    url "https://files.pythonhosted.org/packages/a0/67/ea89394e3f70feb3b9f8b753e75f2aa27a5d4e7b15063c740add20cea437/identify-1.4.28.tar.gz"
    sha256 "d6ae6daee50ba1b493e9ca4d36a5edd55905d2cf43548fdc20b2a14edef102e7"
  end

  resource "nodeenv" do
    url "https://files.pythonhosted.org/packages/3e/8f/5cc2a548f8992eba34328788ae09acf1432f3cec65bcb95f1e45c655a487/nodeenv-1.4.0.tar.gz"
    sha256 "26941644654d8dd5378720e38f62a3bac5f9240811fb3b8913d2663a17baa91c"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/64/c2/b80047c7ac2478f9501676c988a5411ed5572f35d1beff9cae07d321512c/PyYAML-5.3.1.tar.gz"
    sha256 "b8eac752c5e14d3eca0e6dd9199cd627518cb5ec06add0de9d32baeee6fe645d"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/da/24/84d5c108e818ca294efe7c1ce237b42118643ce58a14d2462b3b2e3800d5/toml-0.10.1.tar.gz"
    sha256 "926b612be1e5ce0634a2ca03470f95169cf16f939018233a670519cb4ac58b0f"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/aa/bd/2a3082a5af997eef7324a3557d2ef3fa641e064c79c33404013310297e45/virtualenv-20.0.31.tar.gz"
    sha256 "43add625c53c596d38f971a465553f6318decc39d98512bc100fa1b1e839c8dc"
  end

  def install
    # Point hook shebang to virtualenv Python.
    # The global one also works - but may be keg-only.
    # A full path can also move around if we use versioned formulae.
    # Git hooks should only have to be installed once and never need changing.
    inreplace "pre_commit/commands/install_uninstall.py",
              "f'#!/usr/bin/env {py}'",
              "'#!#{opt_libexec}/bin/python3'"

    # Avoid Cellar path reference, which is only good for one version.
    inreplace "pre_commit/commands/install_uninstall.py",
              "'INSTALL_PYTHON': sys.executable",
              "'INSTALL_PYTHON': '#{opt_libexec}/bin/python3'"

    virtualenv_install_with_resources
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
