class Copier < Formula
  include Language::Python::Virtualenv

  desc "Utility for rendering projects templates"
  homepage "https://copier.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/ee/44/4e6b8e900218d87ec6fd2ab1db82da31633f137a71b254da74001b86773a/copier-8.3.0.tar.gz"
  sha256 "051149721c811bfa84023fca5c23827917ac5f42ab6c2696dcb522b17aee7cae"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5e4a5699335a84ece3651da2074bae257a7a36d9c36687636afe45b54a7e3b7a"
    sha256 cellar: :any,                 arm64_monterey: "bc5c65a24190c7ef45da75ca965ac23eed3c663e6645786e9a55038cffd62a00"
    sha256 cellar: :any,                 arm64_big_sur:  "20226abbf853e0dd78f062ea75c431e3c3e76e87013933b77989776b62c1d19e"
    sha256 cellar: :any,                 ventura:        "71edbc52119dcfc3d63a140a4368a8f0e1cbac1d2498bde31d67c0ad10e69184"
    sha256 cellar: :any,                 monterey:       "1de6dcc445183e757f6cadebc4a0c71c8ed01869b328e32e3039111f59c5f8e0"
    sha256 cellar: :any,                 big_sur:        "cd885f2f96ed5e38aa48b092b9580f52eae91923eace3892de362728d3c46fd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01a44181bea69863c5c00bd8adc36864cebfeaeeb7c884c277cdf9a4d8c73e9e"
  end

  depends_on "rust" => :build
  depends_on "pygments"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/42/97/41ccb6acac36fdd13592a686a21b311418f786f519e5794b957afbcea938/annotated_types-0.5.0.tar.gz"
    sha256 "47cdc3490d9ac1506ce92c7aaa76c579dc3509ff11e098fc867e5130ab7be802"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/66/0c/8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952/decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "dunamai" do
    url "https://files.pythonhosted.org/packages/77/c8/845bdb9167570937cada51b586393dded1e77c56db458f350a671c4f1ab9/dunamai-1.18.0.tar.gz"
    sha256 "5200598561ea5ba956a6174c36e402e92206c6a6aa4a93a6c5cb8003ee1e0997"
  end

  resource "funcy" do
    url "https://files.pythonhosted.org/packages/70/b8/c6081521ff70afdff55cd9512b2220bbf4fa88804dae51d1b57b4b58ef32/funcy-2.0.tar.gz"
    sha256 "3963315d59d41c6f30c04bc910e10ab50a3ac4a225868bfa96feed133df075cb"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "jinja2-ansible-filters" do
    url "https://files.pythonhosted.org/packages/1a/27/fa186af4b246eb869ffca8ffa42d92b05abaec08c99329e74d88b2c46ec7/jinja2-ansible-filters-1.3.2.tar.gz"
    sha256 "07c10cf44d7073f4f01102ca12d9a2dc31b41d47e4c61ed92ef6a6d2669b356b"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/6d/7c/59a3248f411813f8ccba92a55feaac4bf360d29e2ff05ee7d8e1ef2d7dbf/MarkupSafe-2.1.3.tar.gz"
    sha256 "af598ed32d6ae86f1b747b82783958b1a4ab8f617b06fe68795c7f026abbdcad"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/a0/2a/bd167cdf116d4f3539caaa4c332752aac0b3a0cc0174cdb302ee68933e81/pathspec-0.11.2.tar.gz"
    sha256 "e0d8d0ac2f12da61956eb2306b69f9469b42f4deb0f3cb6ed47b9cce9996ced3"
  end

  resource "plumbum" do
    url "https://files.pythonhosted.org/packages/8e/3d/6bbc1b93fd394f6cc9fbe098d8e2740063d58c36dd8da876f790458ded46/plumbum-1.8.2.tar.gz"
    sha256 "9e6dc032f4af952665f32f3206567bc23b7858b1413611afe603a3f8ad9bfd75"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/fb/93/180be2342f89f16543ec4eb3f25083b5b84eba5378f68efff05409fb39a9/prompt_toolkit-3.0.36.tar.gz"
    sha256 "3e163f254bef5a03b146397d7c1963bd3e2812f0964bb9a24e6ec761fd28db63"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/fd/fe/8f08bf18b2c53afb4b358fae6e9b3501e169a2c1c9c0cd96f21a40bb7abd/pydantic-2.3.0.tar.gz"
    sha256 "1607cc106602284cd4a00882986570472f193fde9cb1259bceeaedb26aa79a6d"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/cb/fe/8c9363389f8f303fb151895af83ac30e06c0406779fe188b4281a64e4c50/pydantic_core-2.6.3.tar.gz"
    sha256 "1508f37ba9e3ddc0189e6ff4e2228bd2d3c3a4641cbe8c07177162f76ed696c7"
  end

  resource "pyyaml-include" do
    url "https://files.pythonhosted.org/packages/45/ec/f730b826e22e4fad5f86f9130362b053ef970ac391baed22293e279128be/pyyaml-include-1.3.1.tar.gz"
    sha256 "4cb3b4e1baae2ec251808fe1e8aed5d3d20699c541864c8e47ed866ab2f15039"
  end

  resource "questionary" do
    url "https://files.pythonhosted.org/packages/0f/30/b639fff1bb7009ba786c0cbf40f39eba88d06957d3f569240da5672502f9/questionary-2.0.0.tar.gz"
    sha256 "8681b9d9ec751347ab11af2204d063b856d06845b07b442951e081780e8cb8a6"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/5e/5f/1e4bd82a9cc1f17b2c2361a2d876d4c38973a997003ba5eb400e8a932b6c/wcwidth-0.2.6.tar.gz"
    sha256 "a5220780a404dbe3353789870978e472cfe477761f06ee55077256e509b156d0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    params = %w[
      -d python=true
      -d js=true
      -d ansible=false
      -d biggest_kbs=1000
      -d main_branches=null
      -d github=true
    ]
    system bin/"copier", "copy", *params, "--vcs-ref=v0.1.0",
      "https://github.com/copier-org/autopretty.git", "template"
    assert (testpath/"template").directory?
    assert_predicate testpath/"template/.copier-answers.autopretty.yml", :exist?
  end
end
