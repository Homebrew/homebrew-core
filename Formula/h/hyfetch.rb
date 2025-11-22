class Hyfetch < Formula
  include Language::Python::Virtualenv

  desc "Fast, highly customisable system info script with LGBTQ+ pride flags"
  homepage "https://github.com/hykilpikonna/hyfetch"
  url "https://files.pythonhosted.org/packages/d5/c5/80c472f9c616e31853a796006c62ff22170e7dd2576c6d74bf3cab8fe845/hyfetch-2.0.5.tar.gz"
  sha256 "3034f789f64ccbecef5d5fb0103c0b1287f50434a4cdacbc7accfdc6cf7e79ca"
  license "MIT"
  head "https://github.com/hykilpikonna/hyfetch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8e23d042c63d216d9951ae1415f41027de311489de35fdb90b4760787ebc5fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "689a7b9884dcbab33646f59568d8d7817c3ac33b58a4307a1d5047ad728e02a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd5faea5be7465dcf4b25455554c79433fb8e8af0676442095d95b55863d27f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe39c8a8bf21e71bda4a19306b0448f61b0c1f7d67c1094e0e71fc83633b2d5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74be4619e6dd47dc54929697a1fde1ef52419a5b0712fd945161c2017b7448f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "389c8f79c54fafd508d554cb164296392c9e6b3cb9a1577dc2b92b96decae856"
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
