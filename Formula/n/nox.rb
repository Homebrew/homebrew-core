class Nox < Formula
  include Language::Python::Virtualenv

  desc "Flexible test automation for Python"
  homepage "https://nox.thea.codes/"
  url "https://files.pythonhosted.org/packages/0d/22/84a2d3442cb33e6fb1af18172a15deb1eea3f970417f1f4c5fa1600143e8/nox-2025.2.9.tar.gz"
  sha256 "d50cd4ca568bd7621c2e6cbbc4845b3b7f7697f25d5fb0190ce8f4600be79768"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "554fbabf55addaf8cbd65ee2133de6871ffd38a2af3da0177a9e746b5859bf42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "554fbabf55addaf8cbd65ee2133de6871ffd38a2af3da0177a9e746b5859bf42"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "554fbabf55addaf8cbd65ee2133de6871ffd38a2af3da0177a9e746b5859bf42"
    sha256 cellar: :any_skip_relocation, sonoma:        "da455caf1512f3fc3e6517cb384bed3e6b59b17d363c907b4bb5e36e24726ec8"
    sha256 cellar: :any_skip_relocation, ventura:       "da455caf1512f3fc3e6517cb384bed3e6b59b17d363c907b4bb5e36e24726ec8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b6a27ac0a075d93e37595666f75ce0dc5aaa536f6e6df54512f8c9b16ba0fb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efadaff2f65e6b0cacf2fe7b40bd891777f84a2bcab00334cdb7b02269169bdf"
  end

  depends_on "python@3.13"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/0c/be/6c23d80cb966fb8f83fb1ebfb988351ae6b0554d0c3a613ee4531c026597/argcomplete-3.5.3.tar.gz"
    sha256 "c12bf50eded8aebb298c7b7da7a5ff3ee24dffd9f5281867dfe1424b58c55392"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/49/7c/fdf464bcc51d23881d110abd74b512a42b3d5d376a55a831b44c603ae17f/attrs-25.1.0.tar.gz"
    sha256 "1c97078a80c814273a76b2a298a932eb681c87415c11dee0a6921de7f1b02c3e"
  end

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/d3/7a/359f4d5df2353f26172b3cc39ea32daa39af8de522205f512f458923e677/colorlog-6.9.0.tar.gz"
    sha256 "bfba54a1b93b94f54e1f4fe48395725a3d92fd2a4af702f6bd70946bdc0c6ac2"
  end

  resource "dependency-groups" do
    url "https://files.pythonhosted.org/packages/b4/57/cd53c3e335eafbb0894449af078e2b71db47e9939ce2b45013e5a9fe89b7/dependency_groups-1.3.0.tar.gz"
    sha256 "5b9751d5d98fbd6dfd038a560a69c8382e41afcbf7ffdbcc28a2a3f85498830f"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/0d/dd/1bec4c5ddb504ca60fc29472f3d27e8d4da1257a854e1d96742f15c1d02d/distlib-0.3.9.tar.gz"
    sha256 "a60f20dea646b8a33f3e7772f74dc0b2d0772d2837ee1342a00645c81edf9403"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/dc/9c/0b15fb47b464e1b663b1acd1253a062aa5feecb07d4e597daea542ebd2b5/filelock-3.17.0.tar.gz"
    sha256 "ee4e77401ef576ebb38cd7f13b9b28893194acc20a8e68e18730ba9c0e54660e"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/13/fc/128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4/platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/a7/ca/f23dcb02e161a9bba141b1c08aa50e8da6ea25e6d780528f1d385a3efe25/virtualenv-20.29.1.tar.gz"
    sha256 "b8b8970138d32fb606192cb97f6cd4bb644fa486be9308fb9b63f81091b5dc35"
  end

  def install
    virtualenv_install_with_resources
    (bin/"tox-to-nox").unlink

    generate_completions_from_executable(libexec/"bin/register-python-argcomplete", "nox",
                                         shell_parameter_format: :arg)
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
