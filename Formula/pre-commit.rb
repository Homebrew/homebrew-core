class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "https://pre-commit.com/"
  url "https://files.pythonhosted.org/packages/81/51/9c5854bec705a95bc8533c4cd65b360c04bbd5680f83d59e6ebe2c4426ed/pre_commit-2.11.1.tar.gz"
  sha256 "de55c5c72ce80d79106e48beb1b54104d16495ce7f95b0c7b13d4784193a00af"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "4b8edc0995b9e2b6c5bfafd856eb0e0ecb31ed6cded514640acd146aa2072477"
    sha256 cellar: :any, big_sur:       "986e1ff0af301b35c603cb91406c2a4f10f57f71715b92416a1912817264d33f"
    sha256 cellar: :any, catalina:      "69407d220808ce6bc532abd02d62e76ad2fa39ecacc00fed48502a0a4f6c07e5"
    sha256 cellar: :any, mojave:        "3536f11bb1cc89d5073bb05283b9dcec4da2989a30f1f0c978de628084556a23"
  end

  depends_on "libyaml"
  depends_on "python@3.9"

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
    url "https://files.pythonhosted.org/packages/e7/cf/7e2c0c72ba53c54d2183bfbdde395b9384790ff67fd2f3208937c39a44b3/identify-2.1.1.tar.gz"
    sha256 "da3d757c94596c50865aae63db6ba4e2e5e3f666c3ea6a6da0cd09a8b2d34abc"
  end

  resource "nodeenv" do
    url "https://files.pythonhosted.org/packages/2f/15/d1eb0d2664e57da61622a815efe7a88db68c7a593fb86bd7cc629fc31c76/nodeenv-1.5.0.tar.gz"
    sha256 "ab45090ae383b716c4ef89e690c41ff8c2b257b85b309f01f3654df3d084bd7c"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/79/64/203241c2e2b5abfd5edca4e28242c21bf8a9e84490873e4a8a155a9658fc/virtualenv-20.4.2.tar.gz"
    sha256 "147b43894e51dd6bba882cf9c282447f780e2251cd35172403745fc381a0a80d"
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
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    bin_python_path = Pathname(libexec/"bin")
    lib_python_path = Pathname(libexec/"lib/python#{xy}")
    [lib_python_path, bin_python_path].each do |folder|
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
