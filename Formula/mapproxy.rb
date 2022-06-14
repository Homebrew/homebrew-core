class Mapproxy < Formula
  include Language::Python::Virtualenv

  desc "Accelerating web map proxy"
  homepage "https://mapproxy.org/"
  url "https://files.pythonhosted.org/packages/33/c3/4cdf29e81aeacc8d2b94520b135cf623983d41e6fdbc81ffbcb7e0dcb17c/MapProxy-1.15.0.tar.gz"
  sha256 "5462cb001b347f3e53ecbd4f5cec737a35285cd6cd6c8501acd71eaebf23114f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7c850b8bdf3952ca8e168227669526b563b5c08c95fdb55f230755a696dc653c"
    sha256 cellar: :any,                 arm64_big_sur:  "54cb52477abef05e85d57a5cb128666dc33351c73da03cc781bb4a2756efba52"
    sha256 cellar: :any,                 monterey:       "cb4a870be4c1fe07cc42f60c206070d36ebe74c1ee3666a477bc1cc31169b4de"
    sha256 cellar: :any,                 big_sur:        "974d5bbfc286e0b64d11af5184d5eee2999c63a08560afdbdb9f545afb3b0b45"
    sha256 cellar: :any,                 catalina:       "4ff88a2511ddb76dfda9a2ace63ddaceff0e0de0aa480ce5ae5ca53f5e5238d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2460e238630303105824e634f1e2f16b986025a4b7305be40ad51c5313db6766"
  end

  depends_on "pillow"
  depends_on "proj"
  depends_on "python@3.9"

  resource "Pillow" do
    url "https://files.pythonhosted.org/packages/43/6e/59853546226ee6200f9ba6e574d11604b60ad0754d2cbd1c8f3246b70418/Pillow-9.1.1.tar.gz"
    sha256 "7502539939b53d7565f3d11d87c78e7ec900d3c72945d4ee0e2f250d598309a0"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"mapproxy-util", "create", "-t", "base-config", testpath
    assert_predicate testpath/"seed.yaml", :exist?
  end
end
