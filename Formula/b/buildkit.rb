class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.13.2",
      revision: "2e18d709fefdcc2db20853ee241c75b058189d39"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5b5c5171ff623c1ad1648feea5283227665de493d3732877ba5a7b30c32304e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c453f4fbf8df94fc010c06b90e8636bece09c3f88223201b2db75eee0c56aa3e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11539d7d9bd13eb95738cd07438992f61d684435aed1cf14b2e2bc1a806d60b5"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e36352e9d8e3622692921589ebc42e6f6309931d6c21173c3fe0b2a383a60b5"
    sha256 cellar: :any_skip_relocation, ventura:        "6a79222f9f89b1a0d9f7b49c9d6d9cb3612c42b1cb0fdf382ba9dfb043717f2f"
    sha256 cellar: :any_skip_relocation, monterey:       "5dc76652aa95820b5467f7e364ec8b0cfa9bec5527e5fe7bb628405fe62a9757"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0342f808bd076941191cde85eb8897d5861f0b4bf16093c8cee7447c8610a05c"
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
