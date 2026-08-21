class Nox < Formula
  include Language::Python::Virtualenv

  desc "Flexible test automation for Python"
  homepage "https://nox.thea.codes/"
  url "https://files.pythonhosted.org/packages/be/65/4cef8ae8f6dbcb5753b202e46791277f1ea0b4a0650d1a6cb940c468b143/nox-2026.8.17.tar.gz"
  sha256 "8d9c69c9b996a59db1eb2c6968deaebc2edbc55317d205981bbc4a37351d3f2e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ce8da1530325854e4907cbb719a04878849b51dbd8f84d0b28de6ea4ae7a6b7e"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/87/6f/5a73f04007ca950701765949209f068da628bd11f9c2da287278ce91e0ee/argcomplete-3.7.2.tar.gz"
    sha256 "aad8b69a0b9969edb62db0d1752354c0d50717b10e0cbb00e2a958381b9fc6b9"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/8c/55/ba79756cb90c8d69d599d57785398ac87bba7b19c80e87f4e8a562197c93/colorlog-6.12.0.tar.gz"
    sha256 "2a7924c1dadf18b22a0eb8b06d1c7b01d5341707ec1641eb6fcc4fde0c3e8e5f"
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
    url "https://files.pythonhosted.org/packages/7d/64/a02e6765de08964ed371eca577870593245afc9dfac16d037de7c10d18e6/filelock-3.32.3.tar.gz"
    sha256 "0ffa185a3540854c95caa7fa76b76cb219d907415e2c5dc9af25fd970563487f"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/0a/ea/13a1ef3c12d12662905801495283530251918b70d62d368f1d2e0272c70d/humanize-4.16.0.tar.gz"
    sha256 "7dc2244a2f84a4bfb1d36c37bac80cd78e35cdc5c119206d87b018e1445f3a3f"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/b8/d7/e7bfbc86e9f99ff7807e24de7703f032e9c9ba80bb355cf26e0e9bc5a75e/platformdirs-4.11.3.tar.gz"
    sha256 "66a73d38a849810252df809a3d8bcbda8e26f6c189920e7535ad608a48dbb5ab"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/38/b7/ac44da2cf0e53ada0e419033c2d058219c95dc1403126f163304c9e814b1/python_discovery-1.5.2.tar.gz"
    sha256 "45fd4f20a4e3f9b7bf2e0817870bc8e3b320a19658da177af800768c82dbf354"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/2d/dc/a6eb1ddfa7f1e390fa599b078453c97edb3f6f846b34fb4eac3e8ea16401/virtualenv-21.7.4.tar.gz"
    sha256 "c9d960c95fa458171e58222a5ccab7465298e4b6559977865e627c4719f1e825"
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
