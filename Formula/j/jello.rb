class Jello < Formula
  include Language::Python::Virtualenv

  desc "Filter JSON and JSON Lines data with Python syntax"
  homepage "https://github.com/kellyjonbrazil/jello"
  url "https://files.pythonhosted.org/packages/8a/1d/25e13e337f0c5c8076a4fc42db02b726529b611a69d816b71f8d591cf0f5/jello-1.6.0.tar.gz"
  sha256 "f0a369b2bd0c1db6cb07abbfd014034c22158c160e3df2a9d55b258bc6fbfa42"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c70f6bf5486c8c06653f3d28c44450ae67d9ade3ef710631f353da6101fe0be4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af6054810021f2d286da8369eb5b68d60e09a52cc2199825c891b568897a0ac6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51b0db309fbb4deb81b77a8fb954af611643b26a2b75c8ea7f2c5658d2757e37"
    sha256 cellar: :any_skip_relocation, sonoma:         "39d92acffbac11cc6753a341a6e5538895997ba2977fab82848729e123b54392"
    sha256 cellar: :any_skip_relocation, ventura:        "e5e84745ddbde5e9a77979b4ecd44175865a84f683c7175d6b0eecf888733e56"
    sha256 cellar: :any_skip_relocation, monterey:       "14bab84aba6920a3520fdc09b5679f7716ad73afc1e0da3ebe7231f725586be3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec5972dc34b0f729637a56f358c9a3e1f56906a54264c64cc625fdae5352935e"
  end

  depends_on "python@3.12"

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/55/59/8bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565/pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  def install
    virtualenv_install_with_resources
    man1.install "man/jello.1"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}/jello _.foo", "{\"foo\":1}")
  end
end
