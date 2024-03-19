class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/refs/tags/v0.42.9.tar.gz"
  sha256 "5b29f0223cd583e02519d741ec1ee9dbf2ba759a0b0ffbd8e1e68ab621dd37b5"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "971ca77fe215fb9bc44af242eaec8398d00bcfdcb105cf3ebd9edf8334c86214"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91eac41ae90e5bf09bfa89f21146fc4d39f63fa9cb9e372f000ae3f93337e888"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc3ad22af6813ec9038334b2738847bbab1e2d63fe24283feedd06cad23e9dae"
    sha256 cellar: :any_skip_relocation, sonoma:         "c254240ec2b688d37d6d6a9120b6314b53e971b1f91cd3cecb6d14a7065037a7"
    sha256 cellar: :any_skip_relocation, ventura:        "4dc6a99c0c9ad5cddb07ad7d8d6fd3f93b5997f57e843142f7f68eae95397452"
    sha256 cellar: :any_skip_relocation, monterey:       "cc3aaf8a3b8550d8c2f0f6ed028e8da8a22a77d6e6110eabfd4b9d43b9ce5509"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1176fee493f0853f68d7217be3bdb0246a48a7d7b41d01f465a57cab56d6c343"
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
