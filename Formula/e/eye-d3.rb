class EyeD3 < Formula
  include Language::Python::Virtualenv

  desc "Work with ID3 metadata in .mp3 files"
  homepage "https://eyed3.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/ee/aa/5873b98fa5f570724a65757987c155dea68d27f0acae17da1b1ffc8cd0d2/eyed3-0.9.9.tar.gz"
  sha256 "a8affaae19384aca66f6efef3babd705042a76e546f08e886f5f28691ac62a3b"
  license "GPL-3.0-or-later"
  head "https://github.com/nicfit/eyeD3.git", branch: "0.9.x"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c6bbc59b8cca30423c14cd273ec694b3025e2c3aa2b6425966301121fb791889"
  end

  depends_on "python@3.14"

  resource "deprecation" do
    url "https://files.pythonhosted.org/packages/5a/d3/8ae2869247df154b64c1884d7346d412fed0c49df84db635aab2d1c40e62/deprecation-2.1.0.tar.gz"
    sha256 "72b3bde64e5d778694b0cf68178aed03d15e15477116add3fb773e581f9518ff"
  end

  resource "filetype" do
    url "https://files.pythonhosted.org/packages/bb/29/745f7d30d47fe0f251d3ad3dc2978a23141917661998763bebb6da007eb1/filetype-1.2.0.tar.gz"
    sha256 "66b56cd6474bf41d8c54660347d37afcc3f7d1970648de365c102ef77548aadb"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  def install
    virtualenv_install_with_resources
    doc.install Dir["docs/*"]
  end

  test do
    cp test_fixtures("test.mp3"), testpath
    assert_match "No ID3 v1.x/v2.x tag found", shell_output("#{bin}/eyeD3 test.mp3 2>&1")
    system bin/"eyeD3", "--artist", "HomebrewYo", "--track", "37", "test.mp3"
    assert_match "artist: HomebrewYo", shell_output("#{bin}/eyeD3 test.mp3 2>&1")
  end
end
