class Hyfetch < Formula
  include Language::Python::Virtualenv

  desc "Fast, highly customisable system info script with LGBTQ+ pride flags"
  homepage "https://github.com/hykilpikonna/hyfetch"
  url "https://files.pythonhosted.org/packages/69/a8/df23913bb5e6791f339ca477558e14d1a43a23ebe72336e80001e188179e/hyfetch-2.1.0.tar.gz"
  sha256 "257eb5effcdd58bfaee9e7e6460e04c1fd5b5693385d6de1d32739085c44b4bf"
  license "MIT"
  head "https://github.com/hykilpikonna/hyfetch.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f5dfbd1a513b338279e54ad3e7ea03ead8e95c2ef91b59cd2cde5cd834e15bf9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2cb10da0647858066e0b5801b606f2a6d80448503436e1b501c07075f411fee6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "18a328e3f0f9fa1b58c9fe051770dac5ea9a3acfeba9cc3c5488384ba779fa14"
    sha256 cellar: :any,                 arm64_linux:       "4ac2b1aa69bdb2fcb29bdb5319f8dfe70f00ccf89d39bfe3aaa002ec12598ad7"
    sha256 cellar: :any,                 x86_64_linux:      "e5846904ce4697618de416eacb96cfbf214b48ed60d6b9f47a1e055835832402"
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
