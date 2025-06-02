class Pipx < Formula
  include Language::Python::Virtualenv

  desc "Execute binaries from Python packages in isolated environments"
  homepage "https://pipx.pypa.io"
  url "https://files.pythonhosted.org/packages/17/21/dd6b9a9c4f0cb659ce3dad991f0e8dde852b2c81922224ef77df4222ab7a/pipx-1.7.1.tar.gz"
  sha256 "762de134e16a462be92645166d225ecef446afaef534917f5f70008d63584360"
  license "MIT"
  revision 1
  head "https://github.com/pypa/pipx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca676ccaaf770e835c5a9ae2d3a648ef4539893c02aa8a70875bfd3e338b8484"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca676ccaaf770e835c5a9ae2d3a648ef4539893c02aa8a70875bfd3e338b8484"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ca676ccaaf770e835c5a9ae2d3a648ef4539893c02aa8a70875bfd3e338b8484"
    sha256 cellar: :any_skip_relocation, sonoma:        "69ef5656f96b42ca04100279ec7319a7c82217550028e245ccf5f05638986799"
    sha256 cellar: :any_skip_relocation, ventura:       "69ef5656f96b42ca04100279ec7319a7c82217550028e245ccf5f05638986799"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c2f3a3c349cb76bc1cbb52c387500db77c0bdb79d9acc835a008efdac9d1630"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "621bb41e77afe49a6f4b2042485659267c80617331e8a1728ee1f31ff02c0c10"
  end

  depends_on "python@3.13"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/7f/03/581b1c29d88fffaa08abbced2e628c34dd92d32f1adaed7e42fc416938b0/argcomplete-3.5.2.tar.gz"
    sha256 "23146ed7ac4403b70bd6026402468942ceba34a6732255b9edf5b7354f68a6bb"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/13/fc/128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4/platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "userpath" do
    url "https://files.pythonhosted.org/packages/d5/b7/30753098208505d7ff9be5b3a32112fb8a4cb3ddfccbbb7ba9973f2e29ff/userpath-1.9.2.tar.gz"
    sha256 "6c52288dab069257cc831846d15d48133522455d4677ee69a9781f11dbefd815"
  end

  def python3
    deps.map(&:to_formula)
        .find { |f| f.name.start_with?("python@") }
  end

  def install
    # Avoid Cellar path reference, which is only good for one version.
    inreplace "src/pipx/interpreter.py",
              "DEFAULT_PYTHON = _get_sys_executable()",
              "DEFAULT_PYTHON = '#{python3.opt_libexec/"bin/python"}'"

    virtualenv_install_with_resources

    generate_completions_from_executable(libexec/"bin/register-python-argcomplete", "pipx",
                                         shell_parameter_format: :arg)
  end

  test do
    assert_match "PIPX_HOME", shell_output("#{bin}/pipx --help")
    system bin/"pipx", "install", "csvkit"
    assert_path_exists testpath/".local/bin/csvjoin"
    system bin/"pipx", "uninstall", "csvkit"
    refute_match "csvjoin", shell_output("#{bin}/pipx list")
  end
end
