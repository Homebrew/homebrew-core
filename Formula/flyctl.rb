class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.442",
      revision: "e5a70d7975abc029e3b6e090067697220c2766cb"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ef938e352b3bd4836c282001bacc7e4d317249a53d51869de5b207882a623c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ef938e352b3bd4836c282001bacc7e4d317249a53d51869de5b207882a623c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ef938e352b3bd4836c282001bacc7e4d317249a53d51869de5b207882a623c9"
    sha256 cellar: :any_skip_relocation, ventura:        "3678e61c5a829f06423c00b27776057b4b7728b7dd92d510dd938990eb4f607b"
    sha256 cellar: :any_skip_relocation, monterey:       "3678e61c5a829f06423c00b27776057b4b7728b7dd92d510dd938990eb4f607b"
    sha256 cellar: :any_skip_relocation, big_sur:        "3678e61c5a829f06423c00b27776057b4b7728b7dd92d510dd938990eb4f607b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83f2cf993e11986d60186f3a60d8dcb65fae4b585bdc7cae2264221cddc87e37"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.environment=production
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.version=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("flyctl status 2>&1", 1)
    assert_match "Error No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
