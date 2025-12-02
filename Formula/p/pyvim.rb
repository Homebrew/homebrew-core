class Pyvim < Formula
  include Language::Python::Virtualenv

  desc "Pure Python Vim clone"
  homepage "https://github.com/prompt-toolkit/pyvim"
  url "https://files.pythonhosted.org/packages/c3/31/04e144ec3a3a0303e3ef1ef9c6c1ec8a3b5ba9e88b98d21442d9152783c1/pyvim-3.0.3.tar.gz"
  sha256 "2a3506690f73a79dd02cdc45f872d3edf20a214d4c3666d12459e2ce5b644baa"
  license "BSD-3-Clause"

  bottle do
    rebuild 6
    sha256 cellar: :any_skip_relocation, all: "1d60636ec54fbcaad3250b79216de6541628e84b08c9bf60d4956ff2c1e0d768"
  end

  depends_on "python@3.14"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/a1/96/06e01a7b38dce6fe1db213e061a4602dd6032a8a97ef6c1a862537732421/prompt_toolkit-3.0.52.tar.gz"
    sha256 "28cde192929c8e7321de85de1ddbe736f1375148b02f2e17edd840042b1be855"
  end

  resource "pyflakes" do
    url "https://files.pythonhosted.org/packages/45/dc/fd034dc20b4b264b3d015808458391acbf9df40b1e54750ef175d39180b1/pyflakes-3.4.0.tar.gz"
    sha256 "b24f96fafb7d2ab0ec5075b7350b3d2d2218eab42003821c06344973d3ea2f58"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/24/30/6b0809f4510673dc723187aeaf24c7f5459922d01e2f794277a3dfb90345/wcwidth-0.2.14.tar.gz"
    sha256 "4d478375d31bc5395a3c55c40ccdf3354688364cd61c4f6adacaa9215d0b3605"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    # Need a pty due to https://github.com/prompt-toolkit/pyvim/issues/101
    require "pty"
    PTY.spawn(bin/"pyvim", "--help") do |r, _w, _pid|
      assert_match "Vim clone", r.read
    end
  end
end
