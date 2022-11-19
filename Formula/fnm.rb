class Fnm < Formula
  desc "Fast and simple Node.js version manager"
  homepage "https://github.com/Schniz/fnm"
  url "https://github.com/Schniz/fnm/archive/v1.32.0.tar.gz"
  sha256 "de298ea71c5c79dcc220674bff651c38cb9dd1c122bdfb576846a27baa1b2cec"
  license "GPL-3.0-only"
  head "https://github.com/Schniz/fnm.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a98ca65c60a9500d59146752aeaddc32b9d5516b9e14a2fce04d07c9bd1cce20"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6725cae6ae21253625640ae157a122113e7f021e0b4b4221273357294d54685d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "831c1b292e8b30728a757ccd16325e96d74acd1c950ae6a1f5a3b105be5b83ad"
    sha256 cellar: :any_skip_relocation, ventura:        "7dc13788c125c244b64d804b25dd30ef09e1f0954d48539adb5c2e6c27f25208"
    sha256 cellar: :any_skip_relocation, monterey:       "63d51fd1a65b083aea2e323f2fbd660949d4581ecd6bb93ce0bef15e2c387064"
    sha256 cellar: :any_skip_relocation, big_sur:        "69b1f03176c6109d202c22c3f72307fb8ebc6ec1f5986269d1465a9259d5cdee"
    sha256 cellar: :any_skip_relocation, catalina:       "b422feb847d4fee1e6229a7ed85f506f9509973dfc8f84c89f517d8dd7cee373"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2970bb57e09c0886b387dd3d4514942d69c1a15dd2f36e8c421272383bf4a9d8"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"fnm", "completions", "--shell")
  end

  test do
    system bin/"fnm", "install", "19.0.1"
    assert_match "v19.0.1", shell_output("#{bin}/fnm exec --using=19.0.1 -- node --version")
  end
end
