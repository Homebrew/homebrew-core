class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.41.1.tar.gz"
  sha256 "999616a53f0e2eaf333008f9058684d26dd4b0f857087376269d643cee5ec6fb"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b307adba0665ad76a87d831fdfb75db00b47404845a08d549e3701bda4d92e0d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bd6e4fa9ee81d3734570255a886e21333880ffb81740f201e7715427f61c0a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99c1756c65244cf17df611d6fb12a838526f26f4caca2e1def10aece8bdf5ffc"
    sha256 cellar: :any_skip_relocation, ventura:        "bf703b61f68170ff50ae04fb4fb7f2957cc3dd7eec3a66b6ab113179f610ab0e"
    sha256 cellar: :any_skip_relocation, monterey:       "03f61397cb566d0a34090c860067fd97af93703e25a8e817ad2145d32a33090c"
    sha256 cellar: :any_skip_relocation, big_sur:        "da2e4d48422715c011bfa360221ba8cb140090ae4733427d5dffe554c82ce0ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8188c259131f243cb9ace9ec882f365caa0225ea2bc83de089e18ef49746ef3a"
  end

  depends_on "go" => :build

  conflicts_with "cadence-workflow", because: "both install a `cadence` executable"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./runtime/cmd/main"
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      pub fun main(): Int {
        return 0
      }
    EOS
    system "#{bin}/cadence", "hello.cdc"
  end
end
