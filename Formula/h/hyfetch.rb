class Hyfetch < Formula
  include Language::Python::Virtualenv

  desc "Fast, highly customisable system info script with LGBTQ+ pride flags"
  homepage "https://github.com/hykilpikonna/hyfetch"
  url "https://files.pythonhosted.org/packages/bb/af/0c4590b16c84073bd49b09ada0756fd9bd75b072e3ba9aec73101f0cc9f4/HyFetch-1.4.11.tar.gz"
  sha256 "9fa2c9c049ebaf0ad6d4e8e076ce90e64a4b9276946a1d2ffb6912bb1a4aa327"
  license "MIT"
  revision 1
  head "https://github.com/hykilpikonna/hyfetch.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b754e3cd3c2e292dcf7bcf6e9f429241f8d10e1cde3e606d97ab1ccedcbe1d8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b754e3cd3c2e292dcf7bcf6e9f429241f8d10e1cde3e606d97ab1ccedcbe1d8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b754e3cd3c2e292dcf7bcf6e9f429241f8d10e1cde3e606d97ab1ccedcbe1d8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "74af52c7460c51175930a3b44b67817b284a259583b1cfe810437d8f16ab5f06"
    sha256 cellar: :any_skip_relocation, ventura:       "74af52c7460c51175930a3b44b67817b284a259583b1cfe810437d8f16ab5f06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ece3b8c1f3d62805822839f483448ca8c70c401419a8644595df47f3e9a32404"
  end

  depends_on "python@3.13"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/27/b8/f21073fde99492b33ca357876430822e4800cdf522011f18041351dfa74b/setuptools-75.1.0.tar.gz"
    sha256 "d59a21b17a275fb872a9c3dae73963160ae079f1049ed956880cd7c09b120538"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
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

    system bin/"neowofetch", "--config", "none", "--color_blocks", "off",
                              "--disable", "wm", "de", "term", "gpu"
    system bin/"hyfetch", "-C", testpath/"hyfetch.json",
                             "--args=\"--config none --color_blocks off --disable wm de term gpu\""
  end
end
