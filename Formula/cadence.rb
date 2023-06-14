class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.39.8.tar.gz"
  sha256 "2fa4b2642d4abf30a2eec5aa72c104cb7d8ed46cf76e080efa0e0308cbe95946"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5a6b0faca1a928be20a5d8c380012b2d3d6d8e12c3632482fb8658f7ac0a364"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5a6b0faca1a928be20a5d8c380012b2d3d6d8e12c3632482fb8658f7ac0a364"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5a6b0faca1a928be20a5d8c380012b2d3d6d8e12c3632482fb8658f7ac0a364"
    sha256 cellar: :any_skip_relocation, ventura:        "ab7c9af020a0137511bff930a2ee77123926f7aa7cb5211a54e39e723ea8432e"
    sha256 cellar: :any_skip_relocation, monterey:       "ab7c9af020a0137511bff930a2ee77123926f7aa7cb5211a54e39e723ea8432e"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab7c9af020a0137511bff930a2ee77123926f7aa7cb5211a54e39e723ea8432e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b1110ae5a9594e2d02a4385add07235fa1b6a2e67eca280f66f49994d2dbf72"
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
