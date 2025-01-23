class Pytest < Formula
  include Language::Python::Virtualenv

  desc "Simple powerful testing with Python"
  homepage "https://docs.pytest.org/en/latest/"
  url "https://files.pythonhosted.org/packages/05/35/30e0d83068951d90a01852cb1cef56e5d8a09d20c7f511634cc2f7e0372a/pytest-8.3.4.tar.gz"
  sha256 "965370d062bce11e73868e0335abac31b4d3de0e82f4007408d242b4f8610761"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c54028c072f46ee630dae2195a82a6dcc133e55715e40189a1ee6157a37c1445"
  end

  depends_on "python@3.13"

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/d7/4b/cbd8e699e64a6f16ca3a8220661b5f83792b3017d0f79807cb8708d33913/iniconfig-2.0.0.tar.gz"
    sha256 "2d91e135bf72d31a410b17c16da610a82cb55f6b0477d1a902134b24a455b8b3"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/96/2d/02d4312c973c6050a18b314a5ad0b3210edb65a906f868e31c111dede4a6/pluggy-1.5.0.tar.gz"
    sha256 "2cffa88e94fdc978c4c574f15f9e59b7f4201d439195c3715ca9e2486f1d0cf1"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test_example.py").write <<~PYTHON
      def test_example():
          assert 1 + 1 == 2
    PYTHON
    system bin/"pytest", "test_example.py"
  end
end
