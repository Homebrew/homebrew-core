class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/refs/tags/v0.42.10.tar.gz"
  sha256 "6b1a9a55bd317b8f7ec7b125621aba264eff5319a6e7ba9d2410498afc76a171"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f7d2238798c13eb3002eedc905940ef0be6f28e5a18d6e7bb132ad4c86262138"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1adb3c369db4b2b2d1d32f53e40f26dfcf1d9e8e5d1ae27749074415a4329172"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae92ad9bdb8fa0fe3638d970ee349d47193a78ef97a153774edc62325c00f945"
    sha256 cellar: :any_skip_relocation, sonoma:         "58f2f32ba130cef7f7cbb0e334fc83c185bd91245e0d3f168d5aa898b017bc8b"
    sha256 cellar: :any_skip_relocation, ventura:        "54f2b2266125030de7bbdcea0fffb2fc6f8ddb1a86c2171653c7b44e13e8cc3b"
    sha256 cellar: :any_skip_relocation, monterey:       "31007312b0301f212e41616d9ae34eface2f08b8f0f7210a06cfb48bf35b53ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffcd8940bce560dc5f46a9aa9367044f368e592477d2cb158a8dbda7aa9596bc"
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
