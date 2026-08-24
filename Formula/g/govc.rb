class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/main/govc"
  url "https://github.com/vmware/govmomi/archive/refs/tags/v0.56.0.tar.gz"
  sha256 "f8f6a90fb59ea6145701b3b2584aed8ce057bb9fcec85a5044e98d7b3bc7c575"
  license "Apache-2.0"
  head "https://github.com/vmware/govmomi.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98967d1c67dba21ca5a5641bffedf6ab46c655d76c32614ac342ca9c10a62edf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98967d1c67dba21ca5a5641bffedf6ab46c655d76c32614ac342ca9c10a62edf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98967d1c67dba21ca5a5641bffedf6ab46c655d76c32614ac342ca9c10a62edf"
    sha256 cellar: :any_skip_relocation, sonoma:        "25566019f616d1d44f37092c3e9055a7676e734576056a9651a0ec41d5ef8881"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4a61da1c92a7a162c78996d4e272146b5fedbcf9f665824be3f93261f1f11f7"
    sha256 cellar: :any,                 x86_64_linux:  "5a6ba08a307fd8cefaa5f161deb956a6783d62da2e8347f728e1cafad4d95ed3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/vmware/govmomi/cli/flags.BuildVersion=#{version}
      -X github.com/vmware/govmomi/cli/flags.BuildCommit=#{tap.user}
      -X github.com/vmware/govmomi/cli/flags.BuildDate=#{time.iso8601}
    ]
    cd "govc" do
      system "go", "build", *std_go_args(ldflags:)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/govc version")
    assert_match "GOVC_URL=foo", shell_output("#{bin}/govc env -u=foo")
  end
end
