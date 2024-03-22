class Hyfetch < Formula
  include Language::Python::Virtualenv

  desc "Fast, highly customisable system info script with LGBTQ+ pride flags"
  homepage "https://github.com/hykilpikonna/hyfetch"
  url "https://files.pythonhosted.org/packages/bb/af/0c4590b16c84073bd49b09ada0756fd9bd75b072e3ba9aec73101f0cc9f4/HyFetch-1.4.11.tar.gz"
  sha256 "9fa2c9c049ebaf0ad6d4e8e076ce90e64a4b9276946a1d2ffb6912bb1a4aa327"
  license "MIT"
  head "https://github.com/hykilpikonna/hyfetch.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc9b32dfd341c20669b1db0abb658b0b84f2bd225e98b90b796c8772f0885c96"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be055f9d7b4a069e385c2cbc4c6170f619e63e4f6e931c9032df7cc5db557a75"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20654b041219c82e17f9487a6c88666196dbe64d612228e2e9812d89457b2d85"
    sha256 cellar: :any_skip_relocation, sonoma:         "b11699ea37702bdd32ff9872433fe61736700539d6ace08e2d223c071f9ab9e2"
    sha256 cellar: :any_skip_relocation, ventura:        "df0ea86cc5560e360156de7476c57b78f123c158b891534977f9ea66c6b00dd5"
    sha256 cellar: :any_skip_relocation, monterey:       "c2d3432862e6793e6d9c3d6a20191c395f0e0c5859a01830b375406e5e32a226"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "696a2463f626ae247bff34e9ed0ab6ee799af788f85537aa2442360b130c7474"
  end

  depends_on "python@3.12"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/c9/3d/74c56f1c9efd7353807f8f5fa22adccdba99dc72f34311c30a69627a0fad/setuptools-69.1.0.tar.gz"
    sha256 "850894c4195f09c4ed30dba56213bf7c3f21d86ed6bdaafb5df5972593bfc401"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/0c/1d/eb26f5e75100d531d7399ae800814b069bc2ed2a7410834d57374d010d96/typing_extensions-4.9.0.tar.gz"
    sha256 "23478f88c37f27d76ac8aee6c905017a143b0b1b886c3c9f66bc2fd94f9f5783"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/".config/hyfetch.json").write <<-EOS
    {
      "preset": "genderfluid",
      "mode": "rgb",
      "light_dark": "dark",
      "lightness": 0.5,
      "color_align": {
        "mode": "horizontal",
        "custom_colors": [],
        "fore_back": null
      },
      "backend": "neofetch",
      "distro": null,
      "pride_month_shown": [],
      "pride_month_disable": false
    }
    EOS
    system "#{bin}/neowofetch", "--config", "none", "--color_blocks", "off",
                              "--disable", "wm", "de", "term", "gpu"
    system "#{bin}/hyfetch", "-C", testpath/"hyfetch.json",
                             "--args=\"--config none --color_blocks off --disable wm de term gpu\""
  end
end
