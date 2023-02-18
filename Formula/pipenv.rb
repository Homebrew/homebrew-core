class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://github.com/pypa/pipenv"
  url "https://files.pythonhosted.org/packages/51/d1/27d338d2dfdac245dff58896e0cf22ab59e521f1593063aa5f47a515ac00/pipenv-2023.2.18.tar.gz"
  sha256 "4e45226d197ad84fa11a9d944cb0e1bfcc197919944d0af96e55adf7e1fdc76c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "226e097ac15853f3c281843803c902eb7b9159902cc1a338c01584e4acdd0440"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5039dab9d43bdc95de19ccef7b7ec74955e35150fa6092100d79b23406298c76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c037317a99611d384ae9b901bb781d956ca0a3aceca16af0172ca0e8b80022f"
    sha256 cellar: :any_skip_relocation, ventura:        "e28411433ad56a38d90fe8f52fd804d5f7554bd4887206132b79d3e4bc4e834e"
    sha256 cellar: :any_skip_relocation, monterey:       "446ef251d05bfa9442356cb76677dd486e84d0c12fada46023952e84491d1aa3"
    sha256 cellar: :any_skip_relocation, big_sur:        "42ff3a579cfde1a64330dd35044d336bbb8c57fe939142c1692b2ed0b84a2f38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cce15a94055afd33265bc615f07b2823cdbe783e4c23c98cfd53dd415b05fa4"
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
    url "https://files.pythonhosted.org/packages/0b/dc/eac02350f06c6ed78a655ceb04047df01b02c6b7ea3fc02d4df24ca87d24/filelock-3.9.0.tar.gz"
    sha256 "7b319f24340b51f55a2bf7a12ac0755a9b03e718311dac567a0f4f7fabd2f5de"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/11/39/702094fc1434a4408783b071665d9f5d8a1d0ba4dddf9dadf3d50e6eb762/platformdirs-3.0.0.tar.gz"
    sha256 "8a1228abb1ef82d788f74139988b137e78692984ec7b08eaa6c65f1723af28f9"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/3d/ad/906d59bbcb0e6178989cee52166a8a6651ddaea18b38e728eaac22e61cad/virtualenv-20.19.0.tar.gz"
    sha256 "37a640ba82ed40b226599c522d411e4be5edb339a0c0de030c0dc7b646d61590"
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
