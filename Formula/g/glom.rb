class Glom < Formula
  include Language::Python::Virtualenv

  desc "Declarative object transformer and formatter, for conglomerating nested data"
  homepage "https://glom.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/78/74/8387f95565ba7c30cd152a585b275ebb9a834d1d32782425c5d2fe0a102c/glom-25.12.0.tar.gz"
  sha256 "1ae7da88be3693df40ad27bdf57a765a55c075c86c971bcddd67927403eb0069"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ea1f1872cf6c6175a7250406b1c6c9a0fac6d33123fbd797c34fc1e33712a5f1"
  end

  depends_on "python@3.14"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
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
