class Hyfetch < Formula
  include Language::Python::Virtualenv

  desc "Fast, highly customisable system info script with LGBTQ+ pride flags"
  homepage "https://github.com/hykilpikonna/hyfetch"
  url "https://files.pythonhosted.org/packages/9a/2e/631d3a18c301573aa37b2ec2b212c7bac850bb0ae475f9875d69298901c8/hyfetch-2.1.1.tar.gz"
  sha256 "3dbc5165eeb1790ff9abbc257f834ff9cc6b0f6edd57ea10fcdd2a691710bc20"
  license "MIT"
  head "https://github.com/hykilpikonna/hyfetch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "328b50f6be9a86fcf9f8b91669d0d5567b20ca700613afb4a87178083622484f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7053413400ba74dbbb7558ceb66d6ff374e4099b36b76fd975824e2d79463ba4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ec1d7f53cbb44dea71e4c32806bb4d9f1e7e138c21d9c3d8c1ec8007b7c980f4"
    sha256 cellar: :any,                 arm64_linux:       "2ce70e608e92411b082f11f05b22b8be4e5dd8907bd216129e1362db1389903a"
    sha256 cellar: :any,                 x86_64_linux:      "557ef73d0e2e844ebf32bd5e8457d1ba1a3e858208d8af8e9208341993af4d66"
  end

  depends_on "rust" => :build
  depends_on "python@3.15"

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/7d/ea/39b988c938f75cb75d7045b5c69f8bfed47ee2152c8837fb403de29d6fb8/prompt_toolkit-3.0.53.tar.gz"
    sha256 "9ec8a0ad96d5c56148b3f914aa79c1564c3fde5d2e6b876e7bc327e353cf8fa6"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/ea/01/e5ac23733628a6bbb91913a765fcf55ee8070d8d991bc88fdaaf805052c7/wcwidth-0.9.4.tar.gz"
    sha256 "fd8d57d3cdfe570e3265c8fab1885c24e34ef40889c0759c0c304a19e9835954"
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
