class E1s < Formula
  desc "TUI for managing AWS ECS, inspired by k9s"
  homepage "https://github.com/keidarcy/e1s"
  url "https://github.com/keidarcy/e1s/archive/refs/tags/v1.0.52.tar.gz"
  sha256 "49180b19f27b2280e2064de7168136e47e2b2d8347534cc67d9a270462aa910c"
  license "MIT"
  head "https://github.com/keidarcy/e1s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77f4d18f005707553b476e37a14fc21af09aabaa3a3c7769c4dc7fcd643c1999"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77f4d18f005707553b476e37a14fc21af09aabaa3a3c7769c4dc7fcd643c1999"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77f4d18f005707553b476e37a14fc21af09aabaa3a3c7769c4dc7fcd643c1999"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a2f871e28feb625e63158e67db5a0471d664f51dfe4559ddcb71b842a52bc99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5776040180d06d78c358b90e611fd40d963f05d81dc2363d94421061f56b32a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b14653e25454b187c0b6a65855e4d3c89526e02358de4b518ee42092b0db111a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/e1s"
  end

  test do
    ENV["AWS_REGION"] = "us-east-1"
    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"

    assert_match version.to_s, shell_output("#{bin}/e1s --version")

    output = shell_output("#{bin}/e1s --json --region us-east-1 2>&1", 1)
    assert_match "e1s failed to start, please check your aws cli credential and permission", output
  end
end
