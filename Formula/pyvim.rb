class Pyvim < Formula
  include Language::Python::Virtualenv

  desc "Pure Python Vim clone"
  homepage "https://github.com/jonathanslenders/pyvim"
  url "https://files.pythonhosted.org/packages/7b/7c/4c44b77642e866bbbe391584433c11977aef5d1dc05da879d3e8476cab10/pyvim-3.0.2.tar.gz"
  sha256 "da94f7a8e8c4b2b4611196987c3ca2840b0011cc399618793e551f7149f26c6a"
  license "BSD-3-Clause"
  revision 3

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a327fd8da8ad04448168ade36f66005a34f764f9ffc29219a6c23e0a48ad0592"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b321a033c9da601baa469130c8bfd363816e9694a2d8caa2d601339e662b7d72"
    sha256 cellar: :any_skip_relocation, monterey:       "99eaa49dc72e36ca0d310ddee27e7a689c94dc66810550999a3f4d1f52116ecc"
    sha256 cellar: :any_skip_relocation, big_sur:        "0dab59c0c17cc65d81a0ce2e83102d42e188169f6a2ae91c2c08b8ec2ffb2038"
    sha256 cellar: :any_skip_relocation, catalina:       "fb348c98666df443ca4290cb74fd0c3d9758389bca62ac72ac8595fc3a0025f9"
    sha256 cellar: :any_skip_relocation, mojave:         "7f3586932432c8244a8d48adc731f122380035b233eb0c1c84d6c6ffb2751e88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4dad3b11d399b088624aff2f5c93e58b1644c4f1a0bf91cd98859521bc6fcb62"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/59/68/4d80f22e889ea34f20483ae3d4ca3f8d15f15264bcfb75e52b90fb5aefa5/prompt_toolkit-3.0.29.tar.gz"
    sha256 "bd640f60e8cecd74f0dc249713d433ace2ddc62b65ee07f96d358e0b152b6ea7"
  end

  resource "pyflakes" do
    url "https://files.pythonhosted.org/packages/15/60/c577e54518086e98470e9088278247f4af1d39cb43bcbd731e2c307acd6a/pyflakes-2.4.0.tar.gz"
    sha256 "05a85c2872edf37a4ed30b0cce2f6093e1d0581f8c19d7393122da7e25b2b24c"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/59/0f/eb10576eb73b5857bc22610cdfc59e424ced4004fe7132c8f2af2cc168d3/Pygments-2.12.0.tar.gz"
    sha256 "5eb116118f9612ff1ee89ac96437bb6b49e8f04d8a13b514ba26f620208e26eb"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    # Need a pty due to https://github.com/jonathanslenders/pyvim/issues/101
    require "pty"
    PTY.spawn(bin/"pyvim", "--help") do |r, _w, _pid|
      assert_match "Vim clone", r.read
    end
  end
end
