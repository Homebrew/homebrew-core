class Hyfetch < Formula
  include Language::Python::Virtualenv

  desc "Fast, highly customisable system info script with LGBTQ+ pride flags"
  homepage "https://github.com/hykilpikonna/hyfetch"
  url "https://files.pythonhosted.org/packages/35/f2/8b24d32c63110d3ba7e5e4c88827827cb05eb4e3d14c6652304c546b0e71/hyfetch-2.0.2.tar.gz"
  sha256 "d11eed4b6082095a9e41272fb846e9ed029b172847c9d30e8646eabee9da2b12"
  license "MIT"
  head "https://github.com/hykilpikonna/hyfetch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a741ff07d2c06f5699c1f4033ce043ef552ed537fbd06af8aaba88e931bed153"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecf7782b7ca99b2ea6ccf9a54e87e2c66a8bce760b5f7f3a992527aa95ad7f02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e89c770eeece455da86877b6345728ca3916b7838a8b333d1560c10b7924159"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "72eacb11247a3faacce42064660b165d58372767ea95b67f12fe2eb1bc713a63"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2f094b69ee84858776042ed1035b557ce3714e18e6f811d82eba87acaca236a"
    sha256 cellar: :any_skip_relocation, ventura:       "a6167bc7bf433fb80a18ca06e123074bbf90f084cc2fd14cec953ab4b1640f13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cabcff935bcf4eb9fd146cca0ee94dbfa84b3d8cdfa1051cb56544f01766b273"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6daced8169bc437ff28c950d27fea8a33f018fec96821f66ec4426be6c4632ab"
  end

  depends_on "rust" => :build
  depends_on "python@3.13"

  def install
    # Install to `buildpath` first or else `virtualenv_install_with_resources` will overwrite it.
    system "cargo", "install", *std_cargo_args(path: "crates/hyfetch", root: buildpath)
    virtualenv_install_with_resources
    # Install the rust executable where the Python package expects it.
    (libexec/Language::Python.site_packages("python3")/"hyfetch/rust").install "bin/hyfetch"
  end

  test do
    (testpath/".config/hyfetch.json").write <<~JSON
      {
        "preset": "genderfluid",
        "mode": "rgb",
        "auto_detect_light_dark": true,
        "light_dark": "dark",
        "lightness": 0.5,
        "color_align": {
          "mode": "horizontal",
          "custom_colors": [],
          "fore_back": null
        },
        "backend": "neofetch",
        "args": "--config none --color_blocks off --disable wm de term gpu",
        "distro": null,
        "pride_month_shown": [],
        "pride_month_disable": false
      }
    JSON

    system bin/"neowofetch", "--config", "none", "--color_blocks", "off",
                             "--disable", "wm", "de", "term", "gpu"
    system bin/"hyfetch", "--config-file=#{testpath}/.config/hyfetch.json"
  end
end
