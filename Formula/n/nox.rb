class Nox < Formula
  include Language::Python::Virtualenv

  desc "Flexible test automation for Python"
  homepage "https://nox.thea.codes/"
  url "https://files.pythonhosted.org/packages/8c/ae/44b519e4074993256fa713a56d97a9e50e2afe0452e8486eaf41e235171f/nox-2026.10.20.tar.gz"
  sha256 "5da57c009c3dfdd762c068d9079b17966ec967a9eb02cd8ebcf016a946eaf67f"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2293fa69bcb4075a996ffcd40374c181ed481a62e4dab79d0574ffe3bb7a3c44"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2293fa69bcb4075a996ffcd40374c181ed481a62e4dab79d0574ffe3bb7a3c44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2293fa69bcb4075a996ffcd40374c181ed481a62e4dab79d0574ffe3bb7a3c44"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "37f9d81c7d708417331deb7851d165ffda341daed65f6baf801a086654fe27f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "06c45287ce7f473ebbb313aa73733e9fd9e01c94431050175649b17788dead21"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.15"

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
    url "https://files.pythonhosted.org/packages/b5/16/65e61d8e837e0d70a99a0d4dd76e2af53357c3a03ed1db8ad9b5786d7f25/dependency_groups-1.3.2.tar.gz"
    sha256 "c81831f43828dbc3987ee247eb198241a0152b8e7ceab10977cc3808eb388ac7"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/68/bc/d36966de7304047a1001a7559fbf266c464bb5d8cc85464536ef8c9bcc32/distlib-0.4.4.tar.gz"
    sha256 "ca4175b4ac7f71223cc30ed7248c45d2b38c2439d8ee6e498ab67ed63cf3508d"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/d8/28/3893324bcadf8f89b1616637468d766af3f625008c0735bf704fdfa86617/filelock-4.2.4.tar.gz"
    sha256 "c6d8663535e1650ee430507b4ffbac7b464dd64b7647ea0112a9f406499d163d"
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
    url "https://files.pythonhosted.org/packages/58/e6/d0abbb256b44e6a05748c6942511ff67db8dbb068de0c35b24bf1b395b09/platformdirs-4.13.5.tar.gz"
    sha256 "05831adf87d392760f4b5c3a0a95579ab5a10b18b9b9bd43680dcb47544788a0"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/f3/ee/cf608372c88ce2c136ee13c69ab6f667dbc0d0c1176af188b4ddc8853e66/python_discovery-1.6.4.tar.gz"
    sha256 "bc70d31f0ec5de11eda13d4d64c16e24b3506a65984684f2b6c98cb83b2ea9df"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/70/aa/bff50daee0488e16d611258a9b6c5a1d0c9e128f8ca424e9f4e1c0444ef2/virtualenv-21.14.13.tar.gz"
    sha256 "de5307ba4b9a0001d9c8ea02832d38f63ca432880f416c1bface61c4323fd905"
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
