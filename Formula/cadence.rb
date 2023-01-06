class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.31.2.tar.gz"
  sha256 "33bb675464302e892657efc22848c1df668e05a99375dd156ca83a385aedcd3c"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd9eab683604499ff8d186ae0a6c76f35f296768f171d7cb7c1cb629fb4d2585"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b96249f11bad2782f962f23b70f13e837aff01ccd1494f4919cf8553080853b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe258cc5b479337e86c52e727b4f7de4ab5db7bc2e8bb3323168927fbb21cdc9"
    sha256 cellar: :any_skip_relocation, ventura:        "86acbb78529060844b49b04b81291dfd074543ce14c7ca9a3afa70dc6f9b9d1c"
    sha256 cellar: :any_skip_relocation, monterey:       "3da6d8dd88806aa94438c4ddd8467c376ec3273e05ae3125ae7e8a6c9280d2aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1abd2a5a48a957589b46c4e55c49bd35b2b0376881c7ec8a30cf3fa4ac5dc9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "517939c4a7d0630724cd6717590c47e45f56dc53990947c4918e84e9a55f31ec"
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
