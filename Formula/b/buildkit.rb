class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.15.2",
      revision: "9e14164a1099d3e41b58fc879cbdd6f2b2edb04e"
  license "Apache-2.0"
  head "https://github.com/moby/buildkit.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "234b84ed9ccce93d7376311c7599bb818eb22a14413d7eaee5fbacd6cf83513b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "18d0fe6581cd944b672b66e00a8f391f33ae7e819e84ccf2da05651323b06df7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff99dfaaeab016ec4f8095888f94d3a325438f6f72e1602db897cd64c68afa37"
    sha256 cellar: :any_skip_relocation, sonoma:         "8a320f262d32ee66636e8d55334739c2c8a6cb55ab09f955f393e6e91db2ca33"
    sha256 cellar: :any_skip_relocation, ventura:        "ad7093878ebdb471013013e336efcd3cb5ca7a9200c5d83da23395870d44222b"
    sha256 cellar: :any_skip_relocation, monterey:       "9b767cee604efddb11c92db4f793fa2e29044d51eca031f0457ce3ad6df36f36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e2c484976d4f6e90287b5c6fe6b849c10ac192df6d5715da2fa17cacab71d0f"
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

    system "go", "build", "-mod=vendor", *std_go_args(ldflags:, output: bin/"buildctl"), "./cmd/buildctl"

    doc.install Dir["docs/*.md"]
  end

  test do
    assert_match "make sure buildkitd is running",
      shell_output("#{bin}/buildctl --addr unix://dev/null --timeout 0 du 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/buildctl --version")
  end
end
