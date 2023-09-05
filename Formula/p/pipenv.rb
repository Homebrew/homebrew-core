class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://github.com/pypa/pipenv"
  url "https://files.pythonhosted.org/packages/d3/81/aea032f01a7b12be4a988a0017c22cf98df141051e39de50635f4cccd063/pipenv-2023.9.1.tar.gz"
  sha256 "f6360a83fcb137a20ea87c084d0cfca5ad85359fe2ea110849032d80bc7b0011"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d20ba60968061fe701bd897b01defc9a189c688c8e51dd5c848818b63c4ee1c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6dcf58006bf881befe08ab339b95db98bb1f3324a9f37aa2a8d7033fbb52c03f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03ab2d6f63d8aa83da550d55de61d96648883f31bc7dfd746881d7e111e005f0"
    sha256 cellar: :any_skip_relocation, ventura:        "d6136d2fb5f5b1db059836623d1986b1dccdf5cae2c94e23907aeab1537341d0"
    sha256 cellar: :any_skip_relocation, monterey:       "dad0b791257fe9275c71d8368879b092168314130d4554d9c3b6ba2b40ecb5a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "7716f80d5974509167cfa9a56232ba2832e0ec636b46946d9817ec48da4bf995"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd1ae0ec50a8aa809d7a14a67d6dfa60f99f4b709fb2ad7f4e729f9bdd3b0525"
  end

  depends_on "python-certifi"
  depends_on "python@3.11"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/29/34/63be59bdf57b3a8a8dcc252ef45c40f3c018777dc8843d45dd9b869868f0/distlib-0.3.7.tar.gz"
    sha256 "9dafe54b34a028eafd95039d5e5d4851a13734540f1331060d31c9916e7147a8"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/5a/47/f1f3f5b6da710d5a7178a7f8484d9b86b75ee596fb4fefefb50e8dd2205a/filelock-3.12.3.tar.gz"
    sha256 "0ecc1dd2ec4672a10c8550a8182f1bd0c0a5088470ecd5a125e45f49472fac3d"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/dc/99/c922839819f5d00d78b3a1057b5ceee3123c69b2216e776ddcb5a4c265ff/platformdirs-3.10.0.tar.gz"
    sha256 "b45696dab2d7cc691a3226759c0d3b00c47c8b6e293d96f6436f733303f77f6d"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/a6/8e/2ebdf99a0dd15249272780e34fa40e3becfd28689505979d3ec6aa2f6ce1/virtualenv-20.24.4.tar.gz"
    sha256 "772b05bfda7ed3b8ecd16021ca9716273ad9f4467c801f27e83ac73430246dca"
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
