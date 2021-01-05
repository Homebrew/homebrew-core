class Cppman < Formula
  include Language::Python::Virtualenv

  desc "C++ 98/11/14/17/20 manual pages from cplusplus.com and cppreference.com"
  homepage "https://github.com/aitjcize/cppman"
  url "https://files.pythonhosted.org/packages/39/65/7b2e4041ed2f64295ad7b872bbc7a807f47baba75f29652e790fdd5dc432/cppman-0.5.2.tar.gz"
  sha256 "f7c37a2fcfa5a0dc622da87dbc36c1b24339592c28be57012aab6cdeefe48dcc"
  license "GPL-3.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "003314ab635e36347d9933dede15116782f315be4a9b01fd9d8c9dcae38ce6be" => :big_sur
    sha256 "630b223fd9b57b3efd1d9550b1a322843a5a267f6c8102c12826ae52f5a667f8" => :arm64_big_sur
    sha256 "4b80eea61f0f7c9050c52a076f297a591f3482513350532f00c039a4cba58860" => :catalina
    sha256 "70c43842a449dd2fc325c188a79d48e0465bca0fa3909d92807d4860cb71898b" => :mojave
    sha256 "c8fd2f679703f64dfe3f2cb8a073c10fff3b5db4325291643e07c4c13dc37211" => :high_sierra
  end

  depends_on "python@3.9"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/6b/c3/d31704ae558dcca862e4ee8e8388f357af6c9d9acb0cad4ba0fbbd350d9a/beautifulsoup4-4.9.3.tar.gz"
    sha256 "84729e322ad1d5b4d25f805bfa05b902dd96450f43842c4e99067d5e1369eb25"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/58/5d/445e21e92345848305eecf473338e9ec7ed8905b99ea78415042060127fc/soupsieve-2.1.tar.gz"
    sha256 "6dc52924dc0bc710a5d16794e6b3480b2c7c08b07729505feab2b2c16661ff6e"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "std::extent", shell_output("#{bin}/cppman -f :extent")
  end
end
