class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.22.0",
      revision: "13cf07c97baebd3d5603feecc03f5a46ac98d2a5"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0cf5a667d262ed821e3df3a29fa5960b41e6bb47754b466aefcce0daeb1032dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cf5a667d262ed821e3df3a29fa5960b41e6bb47754b466aefcce0daeb1032dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0cf5a667d262ed821e3df3a29fa5960b41e6bb47754b466aefcce0daeb1032dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "a768fc535322e368f2bbdcb521660c7383624b964fdc774ab5461589a72e3021"
    sha256 cellar: :any_skip_relocation, ventura:       "a768fc535322e368f2bbdcb521660c7383624b964fdc774ab5461589a72e3021"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17750ae944b8fcb251b76927408645b2166e073a0446093eca072ad1e3ceff72"
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
