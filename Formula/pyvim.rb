class Pyvim < Formula
  include Language::Python::Virtualenv

  desc "Pure Python Vim clone"
  homepage "https://github.com/jonathanslenders/pyvim"
  url "https://files.pythonhosted.org/packages/7b/7c/4c44b77642e866bbbe391584433c11977aef5d1dc05da879d3e8476cab10/pyvim-3.0.2.tar.gz"
  sha256 "da94f7a8e8c4b2b4611196987c3ca2840b0011cc399618793e551f7149f26c6a"
  license "BSD-3-Clause"
  revision 2

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

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "prompt_toolkit" do
    url "https://files.pythonhosted.org/packages/69/19/3aa4bf17e1cbbdfe934eb3d5b394ae9a0a7fb23594a2ff27e0fdaf8b4c59/prompt_toolkit-3.0.5.tar.gz"
    sha256 "563d1a4140b63ff9dd587bda9557cffb2fe73650205ab6f4383092fb882e7dc8"
  end

  resource "pyflakes" do
    url "https://files.pythonhosted.org/packages/f1/e2/e02fc89959619590eec0c35f366902535ade2728479fc3082c8af8840013/pyflakes-2.2.0.tar.gz"
    sha256 "35b2d75ee967ea93b55750aa9edbbf72813e06a66ba54438df2cfac9e3c27fc8"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/6e/4d/4d2fe93a35dfba417311a4ff627489a947b01dc0cc377a3673c00cf7e4b2/Pygments-2.6.1.tar.gz"
    sha256 "647344a061c249a3b74e230c739f434d7ea4d8b1d5f3721bc0f3558049b38f44"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/21/9f/b251f7f8a76dec1d6651be194dfba8fb8d7781d10ab3987190de8391d08e/six-1.14.0.tar.gz"
    sha256 "236bdbdce46e6e6a3d61a337c0f8b763ca1e8717c03b369e87a7ec7ce1319c0a"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/25/9d/0acbed6e4a4be4fc99148f275488580968f44ddb5e69b8ceb53fc9df55a0/wcwidth-0.1.9.tar.gz"
    sha256 "ee73862862a156bf77ff92b09034fc4825dd3af9cf81bc5b360668d425f3c5f1"
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
