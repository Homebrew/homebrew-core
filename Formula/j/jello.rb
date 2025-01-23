class Jello < Formula
  include Language::Python::Virtualenv

  desc "Filter JSON and JSON Lines data with Python syntax"
  homepage "https://github.com/kellyjonbrazil/jello"
  url "https://files.pythonhosted.org/packages/8a/1d/25e13e337f0c5c8076a4fc42db02b726529b611a69d816b71f8d591cf0f5/jello-1.6.0.tar.gz"
  sha256 "f0a369b2bd0c1db6cb07abbfd014034c22158c160e3df2a9d55b258bc6fbfa42"
  license "MIT"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, all: "43347f90e4a60a965ce88773aad8fc8bebed4a5ee29f20adc7a31d921b5ce507"
  end

  depends_on "python@3.13"

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  def install
    virtualenv_install_with_resources
    man1.install "man/jello.1"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}/jello _.foo", "{\"foo\":1}")
  end
end
