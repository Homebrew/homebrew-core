class Hyfetch < Formula
  include Language::Python::Virtualenv

  desc "Fast, highly customisable system info script with LGBTQ+ pride flags"
  homepage "https://github.com/hykilpikonna/hyfetch"
  url "https://files.pythonhosted.org/packages/1f/7d/7acc8fd22a1a4861f6a3833fbba8d1ffc6d118d143a4cbaab7f998867b4e/HyFetch-1.99.0.tar.gz"
  sha256 "ddeb422fd797c710f0ad37d584fac466df89e39feddeef765492b2c0b529616e"
  license "MIT"
  head "https://github.com/hykilpikonna/hyfetch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5032952a2e1ded6fc2a2982b8ea254233f5886c54a34717b0affd2890d40765e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5032952a2e1ded6fc2a2982b8ea254233f5886c54a34717b0affd2890d40765e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5032952a2e1ded6fc2a2982b8ea254233f5886c54a34717b0affd2890d40765e"
    sha256 cellar: :any_skip_relocation, sonoma:        "2adf143cdacc67ab16db6094d2bc2fb3f79137d9a0546836ad24a5036fe16769"
    sha256 cellar: :any_skip_relocation, ventura:       "2adf143cdacc67ab16db6094d2bc2fb3f79137d9a0546836ad24a5036fe16769"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cec6b351903878e14e0dc095ec82b8d38fce455d812e17a65af773df0731d34b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5032952a2e1ded6fc2a2982b8ea254233f5886c54a34717b0affd2890d40765e"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/".config/hyfetch.json").write <<~JSON
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
    JSON

    system bin/"neowofetch", "--config", "none", "--color_blocks", "off",
                             "--disable", "wm", "de", "term", "gpu"
    system bin/"hyfetch", "-C", testpath/"hyfetch.json",
                          "--args=\"--config none --color_blocks off --disable wm de term gpu\""
  end
end
