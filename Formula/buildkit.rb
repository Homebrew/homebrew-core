class Buildkit < Formula
  desc "Сoncurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.11.4",
      revision: "3abd1ef0c195cdc078d1657cb50f62a2cdc26f8f"
  license "Apache-2.0"
  head "https://github.com/moby/buildkit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82a051edcb2843816caa1f1fa7fb6b9d6d76423c8068707d75043d8873fe8fd6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ee7cb36a82ad60a77d4867b5bd46b0c10ca4fd40e7eac60e2401e64534822d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "13a073a206dbf870c5ee1df405fb29b41fc3bfae8845781b7ae77b275b6c29b3"
    sha256 cellar: :any_skip_relocation, ventura:        "2d9c0b1568e8e9d306358c9fa0ea8f9f9a338fbd25187abe9cd4cb01a13c2325"
    sha256 cellar: :any_skip_relocation, monterey:       "7428adf1716c54eaefda4c4e2a30fec9624612b7fceee36e0b77bf71590e7660"
    sha256 cellar: :any_skip_relocation, big_sur:        "19fbb4c5e60b4e41e8fc174ad7b99dd068ec6da5dba6e71812350f2ff9c52809"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2c168e94c9000f4157328ec33084b31a9fcf40bfcdce38cc4250e2e967285c5"
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

    system "go", "build", "-mod=vendor", *std_go_args(ldflags: ldflags, output: bin/"buildctl"), "./cmd/buildctl"

    doc.install Dir["docs/*.md"]
  end

  test do
    assert_match "make sure buildkitd is running",
      shell_output("#{bin}/buildctl --addr unix://dev/null --timeout 0 du 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/buildctl --version")
  end
end
