class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://github.com/pypa/pipenv"
  url "https://files.pythonhosted.org/packages/59/d5/198411654335bfea89d7f6c442c46ad4571ddedddd062ab411b9c073a2eb/pipenv-2023.8.26.tar.gz"
  sha256 "8dc593384b4f3b1d5b0db33879093e187e294e74436542d367eb8bb9e7d75f7c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "526750eb1bed8741efe8ad0f87860c94dba9e6c6fe9e1203f85787b00322d778"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b21170deac20f85b34c950108175f943998536d015c49cab82a6d18c0ea8224"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee190cf5a61209d659b8e40ffdd2d561a6fed3eb26c6f933ef4f988a5d377257"
    sha256 cellar: :any_skip_relocation, ventura:        "37ff8388347bae5e3dec83dff1f0aee0e00d597da457eb73b43e90b0637d3f62"
    sha256 cellar: :any_skip_relocation, monterey:       "c5638165c292e290d16e4a0f948b0548ec971541f58a7d4b752c7bdee38a6e90"
    sha256 cellar: :any_skip_relocation, big_sur:        "6479a934c85c0d4dfb2a629febb4d13119673e27e036934734b88aed04d4a9a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdcf6a8df3aaf7a9c1452dd6c1b9e35f49cc8ab19abb2273af4ef43cebcb148e"
  end

  depends_on "python-certifi"
  depends_on "python@3.11"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/29/34/63be59bdf57b3a8a8dcc252ef45c40f3c018777dc8843d45dd9b869868f0/distlib-0.3.7.tar.gz"
    sha256 "9dafe54b34a028eafd95039d5e5d4851a13734540f1331060d31c9916e7147a8"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/00/0b/c506e9e44e4c4b6c89fcecda23dc115bf8e7ff7eb127e0cb9c114cbc9a15/filelock-3.12.2.tar.gz"
    sha256 "002740518d8aa59a26b0c76e10fb8c6e15eae825d34b6fdf670333fd7b938d81"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/dc/99/c922839819f5d00d78b3a1057b5ceee3123c69b2216e776ddcb5a4c265ff/platformdirs-3.10.0.tar.gz"
    sha256 "b45696dab2d7cc691a3226759c0d3b00c47c8b6e293d96f6436f733303f77f6d"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/77/f9/f6319b17869e66571966060051894d7a6dc77feceb25a9ebb6daee7eed5a/virtualenv-20.24.3.tar.gz"
    sha256 "e5c3b4ce817b0b328af041506a2a299418c98747c4b1e68cb7527e74ced23efc"
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
