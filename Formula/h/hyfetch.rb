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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "caceda874883aef8d29aacfb756c2997b6694bf2b04c576950e3433f5c2053bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "caceda874883aef8d29aacfb756c2997b6694bf2b04c576950e3433f5c2053bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "caceda874883aef8d29aacfb756c2997b6694bf2b04c576950e3433f5c2053bd"
    sha256 cellar: :any_skip_relocation, sonoma:         "b2b0e05754b1f53dbff08f34e6c4202bfe3fe821fdfa1fc1eee1518f188ba8bb"
    sha256 cellar: :any_skip_relocation, ventura:        "b2b0e05754b1f53dbff08f34e6c4202bfe3fe821fdfa1fc1eee1518f188ba8bb"
    sha256 cellar: :any_skip_relocation, monterey:       "b2b0e05754b1f53dbff08f34e6c4202bfe3fe821fdfa1fc1eee1518f188ba8bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37ade20596e8b5906ae29d77a23c299b0dfc989c3cb0c819a957aa177225c5c1"
  end

  depends_on "python@3.12"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/65/d8/10a70e86f6c28ae59f101a9de6d77bf70f147180fbf40c3af0f64080adc3/setuptools-70.3.0.tar.gz"
    sha256 "f171bab1dfbc86b132997f26a119f6056a57950d058587841a0082e8830f9dc5"
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
