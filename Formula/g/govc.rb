class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/main/govc"
  url "https://github.com/vmware/govmomi/archive/refs/tags/v0.54.1.tar.gz"
  sha256 "4b9420aeb970087400eff53d09fa72f71a5aa57af28925a0029068ef12aff23f"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "532959340829847c39b9b84f44688c26bc1e1f02f36647a97b45c6b06c4db259"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "532959340829847c39b9b84f44688c26bc1e1f02f36647a97b45c6b06c4db259"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "532959340829847c39b9b84f44688c26bc1e1f02f36647a97b45c6b06c4db259"
    sha256 cellar: :any_skip_relocation, sonoma:        "72142222d73bb27568b51956c753171831adabddfa4f4998e1d2359dece7c518"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "852ddbdacbf6e8b9a17d3b0555ca3e4f9d8a457da19e4d7803bd52f2ef521673"
    sha256 cellar: :any,                 x86_64_linux:  "14dd9b7f7dbe6ef9156500b2bbe7cbd63e2932edf9d14375f9231b833a4b5b0b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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
