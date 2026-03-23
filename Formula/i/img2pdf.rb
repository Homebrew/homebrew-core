class Img2pdf < Formula
  include Language::Python::Virtualenv

  desc "Convert images to PDF via direct JPEG inclusion"
  homepage "https://gitlab.mister-muffin.de/josch/img2pdf"
  url "https://files.pythonhosted.org/packages/8e/97/ca44c467131b93fda82d2a2f21b738c8bcf63b5259e3b8250e928b8dd52a/img2pdf-0.6.3.tar.gz"
  sha256 "219518020f5bd242bdc46493941ea3f756f664c2e86f2454721e74353f58cd95"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "49cb1ad33cd2a254b41237c2ce064bda97dc24f74cfae3b81710ddb7d85be1c9"
    sha256 cellar: :any,                 arm64_sequoia: "b9fe1e781a5fae8818fdd093aba34df2ca8d39c05f44b88ba283f8fccc804d6f"
    sha256 cellar: :any,                 arm64_sonoma:  "da1e80de87f316015f4df8a677889b8b3ddee005180e289da01088ec9b22aeaa"
    sha256 cellar: :any,                 sonoma:        "9f7d81616da3c98aaf7ae9821b1790a321bcb6c5b1ddfa93ed35d1cff5f06748"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8dfa6ee752c5a807e635c0dae1d411f62f0b2be1a7ea63df6367936555eacfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fe8d3cf44d3c9199684b3f457b4aba7397f8c864d57ee60a0b09ac042717c60"
  end

  depends_on "pillow" => :no_linkage
  depends_on "python@3.14"
  depends_on "qpdf"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  pypi_packages exclude_packages: "pillow"

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/49/85/12f0a49a7c4ffb70572b6c2ef13c90c88fd190debda93b23f026b25f9634/deprecated-1.3.1.tar.gz"
    sha256 "b1b50e0ff0c1fddaa5708a2c6b0a6588bb09b892825ab2b214ac9ea9d92a5223"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/aa/88/262177de60548e5a2bfc46ad28232c9e9cbde697bd94132aeb80364675cb/lxml-6.0.2.tar.gz"
    sha256 "cd79f3367bd74b317dda655dc8fcfa304d9eb6e4fb06b7168c5cf27f96e0cd62"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pikepdf" do
    url "https://files.pythonhosted.org/packages/d3/1c/c8c8c53d5f2b1e3e9c9a12ff3442aafd5b368ffb167b03c8328da608d72e/pikepdf-10.0.0.tar.gz"
    sha256 "f1396843aae147328bf221b778725636a1cf33080a46a583b1d18fbb0ca2bcd3"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/49/19/5e5bcd855d808892fe02d49219f97a50f64cd6d8313d75df3494ee97b1a3/wrapt-2.0.0.tar.gz"
    sha256 "35a542cc7a962331d0279735c30995b024e852cf40481e384fd63caaa391cbb9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"img2pdf", test_fixtures("test.png"), test_fixtures("test.jpg"),
                             test_fixtures("test.tiff"), "--pagesize", "A4", "-o", "test.pdf"
    assert_path_exists testpath/"test.pdf"
  end
end
