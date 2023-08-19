class Buildkit < Formula
  desc "Сoncurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.12.1",
      revision: "bb857a0d49f45aa0ce9cd554b78d4075553e20f9"
  license "Apache-2.0"
  head "https://github.com/moby/buildkit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f886469492b744b6fa837deed635b337985811bf5cb4506d4bcb2545fa089ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f886469492b744b6fa837deed635b337985811bf5cb4506d4bcb2545fa089ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f886469492b744b6fa837deed635b337985811bf5cb4506d4bcb2545fa089ff"
    sha256 cellar: :any_skip_relocation, ventura:        "25848e88d9285b22d3021ab57b8343a27694df2311d5ec0a7cde4cad7de43c6e"
    sha256 cellar: :any_skip_relocation, monterey:       "25848e88d9285b22d3021ab57b8343a27694df2311d5ec0a7cde4cad7de43c6e"
    sha256 cellar: :any_skip_relocation, big_sur:        "25848e88d9285b22d3021ab57b8343a27694df2311d5ec0a7cde4cad7de43c6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d766a0ecc2563101181d93f53c15eadd03807ec269ddc407228017d832414842"
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
