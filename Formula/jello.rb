class Jello < Formula
  include Language::Python::Virtualenv

  desc "Filter JSON and JSON Lines data with Python syntax"
  homepage "https://github.com/kellyjonbrazil/jello"
  url "https://files.pythonhosted.org/packages/e0/1a/cfc56d52e2db7cdd1b9641affc14db77c8d9a7850b33f81eebe39eee1fb5/jello-1.5.3.tar.gz"
  sha256 "397b15b7721bfc7fa8b6a11bce8748f6d55013369fec3537dc88a5740e0aef5f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "369fefd4c22c9c012f99788336e08cd270ef1c104b3bf3f9ac606f00bc48b7e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "369fefd4c22c9c012f99788336e08cd270ef1c104b3bf3f9ac606f00bc48b7e8"
    sha256 cellar: :any_skip_relocation, monterey:       "08fe6d928c021346c8995b0a2694e18f32ddb1f4304b4e7ee2bcb4c3e95ab3e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "08fe6d928c021346c8995b0a2694e18f32ddb1f4304b4e7ee2bcb4c3e95ab3e8"
    sha256 cellar: :any_skip_relocation, catalina:       "08fe6d928c021346c8995b0a2694e18f32ddb1f4304b4e7ee2bcb4c3e95ab3e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05c07473b75ec6fb1592da8c3752d16315a8257702cf596ba061571c9b28e56a"
  end

  depends_on "python@3.10"

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/59/0f/eb10576eb73b5857bc22610cdfc59e424ced4004fe7132c8f2af2cc168d3/Pygments-2.12.0.tar.gz"
    sha256 "5eb116118f9612ff1ee89ac96437bb6b49e8f04d8a13b514ba26f620208e26eb"
  end

  def install
    virtualenv_install_with_resources
    man1.install "man/jello.1"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}/jello _.foo", "{\"foo\":1}")
  end
end
