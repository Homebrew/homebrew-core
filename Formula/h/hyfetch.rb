class Hyfetch < Formula
  include Language::Python::Virtualenv

  desc "Fast, highly customisable system info script with LGBTQ+ pride flags"
  homepage "https://github.com/hykilpikonna/hyfetch"
  url "https://files.pythonhosted.org/packages/b7/ab/6445f1799bd410b9459dd19776646fd0f22559f7b7d07bf9f6835efa36c2/hyfetch-2.0.4.tar.gz"
  sha256 "d2e08c60d013e3d06e4046e74d4a4cc7af40f71e7e6d5c5dff1a643d554de5b0"
  license "MIT"
  head "https://github.com/hykilpikonna/hyfetch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c64ad54d5791cc05f8da6a672a3ed3ac2c28319c09836040cbdba2f163e20f22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6e4d5fcbae752925e13e85a80d167f39d8e58947e978523b3697ed9f3ff560a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e8bb41750391c36b68741c9025f5209eb24d92525320efbfb0c45821ead72c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "841e27ab729fcb9794728b839a74e7b8ce0c96823974759925431265deecb7ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8dd6b4fe170ee2fc76baf130abff1e0c02c2bc68bac6cde3ffa0eb2b7135809"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "501f1336fb68a6156f52f3052097ac1599238260ade2b18efdff844c8697517a"
  end

  depends_on "rust" => :build
  depends_on "python@3.14"

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
