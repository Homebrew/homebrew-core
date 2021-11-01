class Matterbridge < Formula
  desc "Protocol bridge for multiple chat platforms"
  homepage "https://github.com/42wim/matterbridge"
  url "https://github.com/42wim/matterbridge/archive/v1.23.1.tar.gz"
  sha256 "6e5e632298534ae5d557e8c6308457d774447169c356ba157fe4532b9a569e9c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a762672c2efd8ab935217af304e0b2edc92523b184e37c6a489cc73c5b3fef2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7aa51cb5f3599d445e7934f57ae310c3430278aa9e33c2ca7f57545ebee63ea6"
    sha256 cellar: :any_skip_relocation, monterey:       "666f96fc79bc07312469ea90cd20eed479e426d1969f531f04a55d831267d2e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d428f099e38a555c4ea5ddd8b03eb80c7aa278688c4d59caa82f28c0f4fc442"
    sha256 cellar: :any_skip_relocation, catalina:       "0224df118dc97b7008c6d13ef88b9116898e64d57548c1c7899d82e97c27bbaf"
    sha256 cellar: :any_skip_relocation, mojave:         "54ab1f978be8c83a3aed7ddcc07561206c28af5119cf4be9b18645be8a872ba5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdeb2a64a4cd343b13e8125ca482efe72a66c4cc666a2ca50e92adf1a0589c75"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    touch testpath/"test.toml"
    assert_match "no [[gateway]] configured", shell_output("#{bin}/matterbridge -conf test.toml 2>&1", 1)
  end
end
