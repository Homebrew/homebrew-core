class Nox < Formula
  include Language::Python::Virtualenv

  desc "Flexible test automation for Python"
  homepage "https://nox.thea.codes/"
  url "https://files.pythonhosted.org/packages/75/bf/aafe066019cb1bcd3e1c22957412d6eb560bd6553c1afd28502168a51418/nox-2026.7.11.tar.gz"
  sha256 "dec9bd2c854540a2d5c0b841eaaf1d23a7c26cd90af36d9f1f1668b34524bfd9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7c8e38c91483ee0a46fd9ab59c533628a77f85135728f031f4ba40dc4b1eeaea"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/95/c0/c8e94135e66fabf89a120d9b4b123fe6993506beca6c1938a74c24cfa5fd/argcomplete-3.7.0.tar.gz"
    sha256 "afde224f753f874807b1dc1414e883ab8fe0cda9c04807b6047dcb8e1ac23913"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/a2/61/f083b5ac52e505dfc1c624eafbf8c7589a0d7f32daa398d2e7590efa5fda/colorlog-6.10.1.tar.gz"
    sha256 "eb4ae5cb65fe7fec7773c2306061a8e63e02efc2c72eba9d27b0fa23c94f1321"
  end

  resource "dependency-groups" do
    url "https://files.pythonhosted.org/packages/62/55/f054de99871e7beb81935dea8a10b90cd5ce42122b1c3081d5282fdb3621/dependency_groups-1.3.1.tar.gz"
    sha256 "78078301090517fd938c19f64a53ce98c32834dfe0dee6b88004a569a6adfefd"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/c9/02/bd72be9134d25ed783ecbbc38a539ffaefbf90c78418c7fb7229600dbac7/distlib-0.4.3.tar.gz"
    sha256 "f152097224a0ae24be5a0f6bae1b9359af82133bce63f98a95f86cae1aede9ed"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/35/94/00f2059e4835eace3ae8fde680b932c496f8ec7bdc99168dfa53fb2e6b79/filelock-3.29.7.tar.gz"
    sha256 "5b481979797ae69e72f0b389d89a80bdd585c260c5b3f1fb9c0a5ba9bb3f195d"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/0a/ea/13a1ef3c12d12662905801495283530251918b70d62d368f1d2e0272c70d/humanize-4.16.0.tar.gz"
    sha256 "7dc2244a2f84a4bfb1d36c37bac80cd78e35cdc5c119206d87b018e1445f3a3f"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d7/47/e4501f49c178ae1d9f4a75073fda4204f52647993f075a9db4d14930e0c5/platformdirs-4.10.0.tar.gz"
    sha256 "31e761a6a0ca04faf7353ea759bdba55652be214725111e5aac52dfa29d4bef7"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/4c/81/58c70036dffeccb7fe7d79d6260c69f7a28272bbd3909c29a01ea9422744/python_discovery-1.4.4.tar.gz"
    sha256 "5cad33982d412c1f3ffb8f9ca4ea292c9680bca3942451d30b69c37fce53a4a3"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/34/d9/b477fddb68840b570af8b22afe9b035cbc277b5fb7b33dea390617a8b10f/virtualenv-21.6.1.tar.gz"
    sha256 "15f978b7cd329f24855ff4a0c4b4899cc7678589f49adbdcbbb4d3232e641128"
  end

  def install
    venv = virtualenv_install_with_resources
    (bin/"tox-to-nox").unlink

    generate_completions_from_executable(libexec/"bin/register-python-argcomplete", "nox",
                                         shell_parameter_format: :arg)

    # Build an `:all` bottle by replacing comments
    file = venv.site_packages.glob("argcomplete-*.dist-info/METADATA")
    inreplace file, "/opt/homebrew/bin/bash", "$HOMEBREW_PREFIX/bin/bash"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    (testpath/"noxfile.py").write <<~PYTHON
      import nox

      @nox.session
      def tests(session):
          session.install("pytest")
          session.run("pytest")
    PYTHON
    (testpath/"test_trivial.py").write <<~PYTHON
      def test_trivial():
          assert True
    PYTHON
    assert_match "usage", shell_output("#{bin}/nox --help")
    assert_match "Sessions defined in #{testpath}/noxfile.py", shell_output("#{bin}/nox --list-sessions")
  end
end
