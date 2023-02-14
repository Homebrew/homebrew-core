class Buildkit < Formula
  desc "Сoncurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.11.3",
      revision: "4ddee42a32aac4cd33bf9c2be4c87c2ffd34747b"
  license "Apache-2.0"
  head "https://github.com/moby/buildkit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61f5a80203c4474ce17dcf2681160191b6fe2235fabd3134acfb9974a5e0acca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74080ffff89008d9922976e2cca7c16ac613f6547d7a3fd6e966d1e672d1e194"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7226a33e801ca78fc769a2da09932bda6abe16addcddab9cbf43e9b4e8de05d5"
    sha256 cellar: :any_skip_relocation, ventura:        "7b5e71efd4a66da35cc75f704eae6ba5f17bf4973e15d7573de27ec9fd7fe949"
    sha256 cellar: :any_skip_relocation, monterey:       "f594826c395b5f5bf8e765cfa7a8297bcdb258d2d7acb0fb22f1435348281e00"
    sha256 cellar: :any_skip_relocation, big_sur:        "64afbfa5465656dd9473484ce2bb8943c172cdb0148e6583ef82f26fcbee0de7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c5b41345d79b5d465f6c00e40d1fea918ddc8c8222d5a9f37ae53297fc3f11e"
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
