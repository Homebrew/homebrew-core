class Buildkit < Formula
  desc "Сoncurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.9.0",
      revision: "c8bb937807d405d92be91f06ce2629e6202ac7a9"
  license "Apache-2.0"
  head "https://github.com/moby/buildkit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fd6929db7f70e9ef5eee31395e392eefff1e596b7f5f9048c3f405cd02401a52"
    sha256 cellar: :any_skip_relocation, big_sur:       "76db05e2e242bdc332b0ece0c22c28cc2b1509a6c57b83516bf9700c71d27566"
    sha256 cellar: :any_skip_relocation, catalina:      "f4a58c4aa6401635fba676aa36ddfb0e91dc6fa10c7246a0210e8dbf85f688db"
    sha256 cellar: :any_skip_relocation, mojave:        "e7dee5f840be67e86e4e8a252ce18e1bccb5dc70385184be0b58b2f312f962ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cc283a28854f3a2ac0a47f3a5be50b18799408516aa45ec90f73e18bd755f5b"
  end

  depends_on "go" => :build

  def install
    revision = Utils.git_head
    ldflags = %W[
      -s -w
      -X github.com/moby/buildkit/version.Version=#{version}
      -X github.com/moby/buildkit/version.Revision=#{revision}
      -X github.com/moby/buildkit/version.Package=github.com/moby/buildkit
    ]

    system "go", "build", "-mod=vendor", "-trimpath",
      "-ldflags", ldflags.join(" "), "-o", bin/"buildctl", "./cmd/buildctl"

    doc.install Dir["docs/*.md"]
  end

  test do
    shell_output("#{bin}/buildctl --addr unix://dev/null --timeout 0 du 2>&1", 1)
  end
end
