class Buildkit < Formula
  desc "Concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
  homepage "https://github.com/moby/buildkit"
  url "https://github.com/moby/buildkit.git",
      tag:      "v0.13.0",
      revision: "2afc050d57d17983f3f662d5424c2725a35c60f4"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6cbb8c0fbde943bd45825d6843c8921bc71413268532a826e84e11cf711c7fcc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40eca1d7086ce98186f7e55571585ad6693d568be8d045bafacad7fbf74926e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "394de6a98ecbb9ea86e15289a5735ee0c466b5e44d98e77fbfa6bddc87bea8d6"
    sha256 cellar: :any_skip_relocation, sonoma:         "11118f67a024840eabe7e4a5bc7b238f97f0c6f385e8fff0c9c65bf35e288c99"
    sha256 cellar: :any_skip_relocation, ventura:        "65f56cd0898eed52d2a356ac6994b6078e9a5bdc1063602222e72a7acde9a036"
    sha256 cellar: :any_skip_relocation, monterey:       "8a5692dbe61d9bb1598433ac08673ef9d12f259a171b5eac463d99cd3cc2ea6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80ee58c5c9d3922eb2cdf8cd1c9e7c3c6ec871b5f3ec398df3ff6a21cea3135b"
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
