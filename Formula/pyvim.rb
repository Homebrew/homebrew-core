class Pyvim < Formula
  include Language::Python::Virtualenv

  desc "Pure Python Vim clone"
  homepage "https://github.com/jonathanslenders/pyvim"
  url "https://files.pythonhosted.org/packages/7b/7c/4c44b77642e866bbbe391584433c11977aef5d1dc05da879d3e8476cab10/pyvim-3.0.2.tar.gz"
  sha256 "da94f7a8e8c4b2b4611196987c3ca2840b0011cc399618793e551f7149f26c6a"

  bottle do
    cellar :any_skip_relocation
    sha256 "4160647aa00e725c752f86c8a712c22f5a885b89bd36c93bae53da3ed4c94d9c" => :catalina
    sha256 "675f003fcf19dc2f5d319c29aa091f10487d93a7a6977533e01bede6ef16ab83" => :mojave
    sha256 "8c2ba98a742053f1a7ba99fa11a92ef81641ff571934c38df26d05235ddc923a" => :high_sierra
  end

  depends_on "python@3.8"

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
    # Need a pty due to https://github.com/jonathanslenders/pyvim/issues/101
    require "pty"
    PTY.spawn(bin/"pyvim", "--help") do |r, _w, _pid|
      assert_match "Vim clone", r.read
    end
  end
end
