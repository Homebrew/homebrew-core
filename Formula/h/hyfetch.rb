class Hyfetch < Formula
  include Language::Python::Virtualenv

  desc "Fast, highly customisable system info script with LGBTQ+ pride flags"
  homepage "https://github.com/hykilpikonna/hyfetch"
  url "https://files.pythonhosted.org/packages/bf/04/13a5091a1da014fad160710abfad2aa03a72bc41e4678c95be2b5ee67818/HyFetch-1.4.10.tar.gz"
  sha256 "023733fa358380fd41589cd80e9b008d376eeef16b489fba8ee8610e71e42057"
  license "MIT"
  head "https://github.com/hykilpikonna/hyfetch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74c829199baf06614089abddeedd82a70d5967ae0964c3fa2e34d48519a977b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6c975ebf3aa75639913ff6d2abbb6aea3fb189a36bb7b81b0f8a535c90c293c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5519c606c25756d691a2e07afd1663e3aac8c7f6448c3ea6092bdfaf5acc57b"
    sha256 cellar: :any_skip_relocation, ventura:        "f8136094deb6770ea45838bc115f138db094e442c4ab08cea52552ea4e603a13"
    sha256 cellar: :any_skip_relocation, monterey:       "72476f31a4a8f21ef3b708747352f990b52fce196a2cc9808b7e007b11afdb63"
    sha256 cellar: :any_skip_relocation, big_sur:        "468c71813f5bb905d0895973676b4b1df6db1546f431b94c27689f5a35040e5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d04b2f649d0072c9f06b97161932ab857be775daaa4dd76f7a53c6c45603c4bd"
  end

  depends_on "python-typing-extensions"
  depends_on "python@3.11"

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
