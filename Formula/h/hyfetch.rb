class Hyfetch < Formula
  include Language::Python::Virtualenv

  desc "Fast, highly customisable system info script with LGBTQ+ pride flags"
  homepage "https://github.com/hykilpikonna/hyfetch"
  url "https://files.pythonhosted.org/packages/69/a8/df23913bb5e6791f339ca477558e14d1a43a23ebe72336e80001e188179e/hyfetch-2.1.0.tar.gz"
  sha256 "257eb5effcdd58bfaee9e7e6460e04c1fd5b5693385d6de1d32739085c44b4bf"
  license "MIT"
  head "https://github.com/hykilpikonna/hyfetch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7110238b75388a62ac4594ecd01d081de27423a73a6d6a3bada4715692674f9a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fb8481ea6441a5aa39f369b75088de5544067e0bf34ba06f25f594893359348b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "598322420d08901cfa2eb3ea2da014ea9e82e1f25a59253054514bd0900dec23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "341fbab3798b23e6d2de5f100e9e8d6e854b29a577b21ca5eca641fb65d43c4d"
    sha256 cellar: :any_skip_relocation, sonoma:            "9366343c6ab96f6fd4335dfad368b9e997c5265eb0204e99a866683509f8a86e"
    sha256 cellar: :any,                 arm64_linux:       "da7e929d591c164c8c5addf38b0d6cd3c555343dfe55b59a2e9f895f55e58444"
    sha256 cellar: :any,                 x86_64_linux:      "f68ee68af3617c677e8667c363e64d5877af8095f2d8f65e256aefa6fdbe426a"
  end

  depends_on "rust" => :build
  depends_on "python@3.15"

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/7d/ea/39b988c938f75cb75d7045b5c69f8bfed47ee2152c8837fb403de29d6fb8/prompt_toolkit-3.0.53.tar.gz"
    sha256 "9ec8a0ad96d5c56148b3f914aa79c1564c3fde5d2e6b876e7bc327e353cf8fa6"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/f0/b4/7830542634bb2d3e62aa3b586a72d5b3b6c91c3168929e7000ef3fed041d/wcwidth-0.9.2.tar.gz"
    sha256 "ae0ef90b90f6af38b54f1fe6d58662ec33b3cb4b8391958a62416d654231727b"
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
