class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://github.com/pypa/pipenv"
  url "https://files.pythonhosted.org/packages/c6/a7/f99bde0978375d8512acef4bca8d75bc7387c4946450a4939e572ad7fc27/pipenv-2023.3.20.tar.gz"
  sha256 "77bbb61bd3d119963fa4b850c62b6f03f82a91664643150a0559f6770539f0b8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "852c686bb4921d9720461987f7dc0f877003a3f80576fc1d301fd22e6a17a7f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d46f7a3854ada6cd4487fb08a0f13857729ee365dad9204aafb4b7c1257d0c55"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e6509556ace81db21d2e9d8045f21d1b05481fb5d2cf9a2ad02230fd1f18f6a7"
    sha256 cellar: :any_skip_relocation, ventura:        "9ab163aab51c8d8ecc6541663df6a7b51e8af93a3f32dfa63cc99648d5905cf1"
    sha256 cellar: :any_skip_relocation, monterey:       "cfc6dc4af6c7a75b5b884eda0b184a5473bc5a9f4867077e9127f718f608b23b"
    sha256 cellar: :any_skip_relocation, big_sur:        "d380997426f82ced94025c980ef7e5844826bbbe5bb6be6fbdbe092a57faa5c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd50b6f48b34bf0c3b1d234dd7601b4f1856da54b1dd697e7b0a3438dcc3574d"
  end

  depends_on "python@3.11"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/58/07/815476ae605bcc5f95c87a62b95e74a1bce0878bc7a3119bc2bf4178f175/distlib-0.3.6.tar.gz"
    sha256 "14bad2d9b04d3a36127ac97f30b12a19268f211063d8f8ee4f47108896e11b46"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/4f/1f/6e1b740698069650b245744957a25957d599b953550a959ab2a584a8825b/filelock-3.10.0.tar.gz"
    sha256 "3199fd0d3faea8b911be52b663dfccceb84c95949dd13179aa21436d1a79c4ce"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/79/c4/f98a05535344f79699bbd494e56ac9efc986b7a253fe9f4dba7414a7f505/platformdirs-3.1.1.tar.gz"
    sha256 "024996549ee88ec1a9aa99ff7f8fc819bb59e2c3477b410d90a16d32d6e707aa"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/87/14/ca9890d58cd33d9122eb87ffec2f3c6be0714785f992a0fd3b56a3b6c993/virtualenv-20.21.0.tar.gz"
    sha256 "f50e3e60f990a0757c9b68333c9fdaa72d7188caa417f96af9e52407831a3b68"
  end

  resource "virtualenv-clone" do
    url "https://files.pythonhosted.org/packages/85/76/49120db3bb8de4073ac199a08dc7f11255af8968e1e14038aee95043fafa/virtualenv-clone-0.5.7.tar.gz"
    sha256 "418ee935c36152f8f153c79824bb93eaf6f0f7984bae31d3f48f350b9183501a"
  end

  def python3
    "python3.11"
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
    (bin/"pipenv").write_env_script libexec/"bin/pipenv", PATH: "#{libexec}/tools:${PATH}"

    generate_completions_from_executable(libexec/"bin/pipenv", shells:                 [:fish, :zsh],
                                                               shell_parameter_format: :click)
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
