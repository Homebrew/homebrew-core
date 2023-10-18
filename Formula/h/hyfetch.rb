class Hyfetch < Formula
  include Language::Python::Virtualenv

  desc "Fast, highly customisable system info script with LGBTQ+ pride flags"
  homepage "https://github.com/hykilpikonna/hyfetch"
  url "https://files.pythonhosted.org/packages/bf/04/13a5091a1da014fad160710abfad2aa03a72bc41e4678c95be2b5ee67818/HyFetch-1.4.10.tar.gz"
  sha256 "023733fa358380fd41589cd80e9b008d376eeef16b489fba8ee8610e71e42057"
  license "MIT"
  head "https://github.com/hykilpikonna/hyfetch.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9405df3b72a2c20b7c8b545cd34eaa0427acd80a6a17ac731432a29e61f40d3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0428c9795b530114be08e3441d5fbd42c8441add7a02943798dde66d42cda7b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7bfac65828faa5dfaf102f8968ed91dc78b7a08b7e388bb53bad3826e1bd2325"
    sha256 cellar: :any_skip_relocation, sonoma:         "bb474bc2b302877b2d0fdfa87b8543a9b7e79999be650d82802fa83f023e3c05"
    sha256 cellar: :any_skip_relocation, ventura:        "cda835fcbe65007c1467ee6f81e082212891b82887a87010d0724cbc267fa8cd"
    sha256 cellar: :any_skip_relocation, monterey:       "b44afb5b713561b86d96c392c0f51f9c2693081f735dd48bd334116b78c948a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac0561bb315ce86c914ef69b98c51ac05347ce1a33612ceb36ab11a08df75fef"
  end

  depends_on "python-setuptools"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"

  on_macos do
    depends_on "screenresolution"
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
