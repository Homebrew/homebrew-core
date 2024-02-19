class Mapproxy < Formula
  include Language::Python::Virtualenv

  desc "Accelerating web map proxy"
  homepage "https://mapproxy.org/"
  url "https://files.pythonhosted.org/packages/ba/09/6ca59563371cf5a0839a1bca32f277f00dc737a213b1bfa72e5ec0dfeca6/MapProxy-2.0.2.tar.gz"
  sha256 "1f03b982faec5bda40af3e112edc4d7c29a216a6bce40022eb004923e17d184f"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "b2b5806283d4c0c606172139d916ed84b170c8a8b921d22133a29cc36a3e8767"
    sha256 cellar: :any,                 arm64_ventura:  "0cfba96c16fe588aa2d1486ec33b075e9a4a1dc801882e2e870fe7a6b0341d6c"
    sha256 cellar: :any,                 arm64_monterey: "5ff08003af115e52f8e8aab51a13d2d00e974630674bdc0416872ece08eefe21"
    sha256 cellar: :any,                 sonoma:         "b779e5baa4128ab54176c1f8d7b75b2e624d9d6d168336f4998ce02f3054073f"
    sha256 cellar: :any,                 ventura:        "05a0664943b29d978dda069f60a14f46d802600dac2b3717e173773772dbe0f3"
    sha256 cellar: :any,                 monterey:       "4f1598077b06000bffb2afad81c65e40886a04a3d4e8c16c26118bd427927feb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dec34448201cb3881d6d25af2eaf7c315881e9e701f1ebf473b23f1a4f6a6ac2"
  end

  depends_on "pillow"
  depends_on "proj"
  depends_on "python-certifi"
  # Should be able to remove python-setuptools dependency in next release,
  # see: https://github.com/mapproxy/mapproxy/pull/863
  depends_on "python-setuptools"
  depends_on "python@3.12"

  resource "pyproj" do
    url "https://files.pythonhosted.org/packages/7d/84/2b39bbf888c753ea48b40d47511548c77aa03445465c35cc4c4e9649b643/pyproj-3.6.1.tar.gz"
    sha256 "44aa7c704c2b7d8fb3d483bbf75af6cb2350d30a63b144279a09b75fead501bf"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"mapproxy-util", "create", "-t", "base-config", testpath
    assert_predicate testpath/"seed.yaml", :exist?
  end
end
