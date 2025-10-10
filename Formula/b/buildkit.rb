class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.25.1",
      revision: "1d4469a951d329d6815394b21084aeca512fcb0d"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da73b3ea99c3dd3059714f2c45cb2afab392e141a4e7e48d7ec64abf8cd0d53c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da73b3ea99c3dd3059714f2c45cb2afab392e141a4e7e48d7ec64abf8cd0d53c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da73b3ea99c3dd3059714f2c45cb2afab392e141a4e7e48d7ec64abf8cd0d53c"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd48d41872875377dbd8fe7ef557048fa9b1cbded79f4344184f002669d39af5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7264371ed8737cf5050359ad8f77643998cad0aed0fd6b97c6c7e6b34894ee52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6371b7e0ad7da333e7df2fe8713cfa0dca3d2dff82c220e9581aadfc6afb916"
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
