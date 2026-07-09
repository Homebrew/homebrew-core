class Hyfetch < Formula
  include Language::Python::Virtualenv

  desc "Fast, highly customisable system info script with LGBTQ+ pride flags"
  homepage "https://github.com/hykilpikonna/hyfetch"
  url "https://files.pythonhosted.org/packages/69/a8/df23913bb5e6791f339ca477558e14d1a43a23ebe72336e80001e188179e/hyfetch-2.1.0.tar.gz"
  sha256 "257eb5effcdd58bfaee9e7e6460e04c1fd5b5693385d6de1d32739085c44b4bf"
  license "MIT"
  head "https://github.com/hykilpikonna/hyfetch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb8481ea6441a5aa39f369b75088de5544067e0bf34ba06f25f594893359348b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "598322420d08901cfa2eb3ea2da014ea9e82e1f25a59253054514bd0900dec23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "341fbab3798b23e6d2de5f100e9e8d6e854b29a577b21ca5eca641fb65d43c4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "9366343c6ab96f6fd4335dfad368b9e997c5265eb0204e99a866683509f8a86e"
    sha256 cellar: :any,                 arm64_linux:   "da7e929d591c164c8c5addf38b0d6cd3c555343dfe55b59a2e9f895f55e58444"
    sha256 cellar: :any,                 x86_64_linux:  "f68ee68af3617c677e8667c363e64d5877af8095f2d8f65e256aefa6fdbe426a"
  end

  depends_on "rust" => :build
  depends_on "python@3.14"

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/a1/96/06e01a7b38dce6fe1db213e061a4602dd6032a8a97ef6c1a862537732421/prompt_toolkit-3.0.52.tar.gz"
    sha256 "28cde192929c8e7321de85de1ddbe736f1375148b02f2e17edd840042b1be855"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/2c/ee/afaf0f85a9a18fe47a67f1e4422ed6cf1fe642f0ae0a2f81166231303c52/wcwidth-0.7.0.tar.gz"
    sha256 "90e3a7ea092341c44b99562e75d09e4d5160fe7a3974c6fb842a101a95e7eed0"
  end

  def install
    # Install to `buildpath` first or else `virtualenv_install_with_resources` will overwrite it.
    system "cargo", "install", *std_cargo_args(path: "crates/hyfetch", root: buildpath)
    venv = virtualenv_install_with_resources
    # Install the rust executable where the Python package expects it.
    (venv.site_packages/"hyfetch/rust").install "bin/hyfetch"
    # Install neowofetch wrapper scrip
    bin.install venv.site_packages/"hyfetch/scripts/neowofetch"
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
