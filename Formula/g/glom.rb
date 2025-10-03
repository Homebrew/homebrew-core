class Glom < Formula
  include Language::Python::Virtualenv

  desc "Declarative object transformer and formatter, for conglomerating nested data"
  homepage "https://glom.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/05/89/b57cfbc448189426f2e01b244fbe9226b059ef5423a9d49c1d335a1f1026/glom-24.11.0.tar.gz"
  sha256 "4325f96759a912044af7b6c6bd0dba44ad8c1eb6038aab057329661d2021bb27"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "26ff4cd82d540ca3d322b553f01d55c3389034204be7ba89b80bb0eb077ca678"
  end

  depends_on "python@3.13"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/49/7c/fdf464bcc51d23881d110abd74b512a42b3d5d376a55a831b44c603ae17f/attrs-25.1.0.tar.gz"
    sha256 "1c97078a80c814273a76b2a298a932eb681c87415c11dee0a6921de7f1b02c3e"
  end

  resource "boltons" do
    url "https://files.pythonhosted.org/packages/63/54/71a94d8e02da9a865587fb3fff100cb0fc7aa9f4d5ed9ed3a591216ddcc7/boltons-25.0.0.tar.gz"
    sha256 "e110fbdc30b7b9868cb604e3f71d4722dd8f4dcb4a5ddd06028ba8f1ab0b5ace"
  end

  resource "face" do
    url "https://files.pythonhosted.org/packages/ac/79/2484075a8549cd64beae697a8f664dee69a5ccf3a7439ee40c8f93c1978a/face-24.0.0.tar.gz"
    sha256 "611e29a01ac5970f0077f9c577e746d48c082588b411b33a0dd55c4d872949f6"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.json").write <<~JSON
      {
        "a": {
          "b": {
            "c": "value"
          }
        }
      }
    JSON

    system bin/"glom", "--target-file", "test.json", "a.b.c"
  end
end
