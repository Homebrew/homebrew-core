class Glom < Formula
  include Language::Python::Virtualenv

  desc "Declarative object transformer and formatter, for conglomerating nested data"
  homepage "https://glom.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/78/74/8387f95565ba7c30cd152a585b275ebb9a834d1d32782425c5d2fe0a102c/glom-25.12.0.tar.gz"
  sha256 "1ae7da88be3693df40ad27bdf57a765a55c075c86c971bcddd67927403eb0069"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "0026e60750543e9be893fc998b66cb70a1f4db947e3d2244d2abe17ecd139507"
  end

  depends_on "python@3.15"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "boltons" do
    url "https://files.pythonhosted.org/packages/71/56/14c4a4931910a81ddeccfbe227925ea738e3c445d3e2af960f0bcbba1616/boltons-26.2.0.tar.gz"
    sha256 "d39cfd15c1a1c3bd4d705c82252fa9edb8e4f5e8cc039f8e39afac7b1b47e92c"
  end

  resource "face" do
    url "https://files.pythonhosted.org/packages/53/fd/f84f0600bd72953d5a322f0dedbd4f900e2cedab718e6b6a093ae2d16aae/face-26.0.1.tar.gz"
    sha256 "8183d94bc248baaea855a9f8445f97a22a9988908e60abddccc6e251da77c4c6"
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
