class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://github.com/pypa/pipenv"
  url "https://files.pythonhosted.org/packages/2e/2f/12ba8e583735de1c66f5636d355bf75986f1c96a41b42c00c05c53484a71/pipenv-2023.9.8.tar.gz"
  sha256 "cfcda864aeb748e6e496b97f20a273477f1e8cc0a3dbb634c133acc5883582ea"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3066a9b67c96011ec36498f020a39f85aff9072d53f25016267bc2c733b97920"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66ec647af668f72afd9d4c61a8b879305ef9de2d22c952a18d1bd461b3bce014"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5a49f7f3928a0316611f3ac14f16084aef3f2112d5f2baff8cf63abe91c14a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "84eee54bea5bf8af6a7ecd8b33f9f56e0cf9269b18afd6a105089db2b2cee4c7"
    sha256 cellar: :any_skip_relocation, sonoma:         "88379da6643b7291f101861ac38355e19a86688f174a70a8ccbb0826cf42abf6"
    sha256 cellar: :any_skip_relocation, ventura:        "3f791d8e77723d287db8633e7a8cfc66eeaa527edb3f3bb0e2f4d224ca082176"
    sha256 cellar: :any_skip_relocation, monterey:       "f615b733b915beeb891c20b83ccaf57608e4534b48beac80caf853bc065b68df"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae1c16fc3d7f9eb2bb812db82b0a9cb613ead50ed2774ba69dc65ada9fbdfb7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9206508be3eb026812550e9168c30783b4adc72d923470f6c64fa6fd145a63c2"
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
