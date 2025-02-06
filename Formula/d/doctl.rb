class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/refs/tags/v1.121.0.tar.gz"
  sha256 "775944a5004d57f398af80570044de08f4109463c6e8efaceb7ba91e1fd3c091"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc59b9609ce705f4d3d9867b5b67ce2ad00b21dbb45c30a90a9508780cd96877"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc59b9609ce705f4d3d9867b5b67ce2ad00b21dbb45c30a90a9508780cd96877"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fc59b9609ce705f4d3d9867b5b67ce2ad00b21dbb45c30a90a9508780cd96877"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c298483fc2430d384c54601d6c4fb22a115269407cd33a79ef6c7cb8cbffee3"
    sha256 cellar: :any_skip_relocation, ventura:       "6c298483fc2430d384c54601d6c4fb22a115269407cd33a79ef6c7cb8cbffee3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25f828e03d9c2a2a0a55bb9e79611cc36e9270be33b02155d95e4a44b24d3ed6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/digitalocean/doctl.Major=#{version.major}
      -X github.com/digitalocean/doctl.Minor=#{version.minor}
      -X github.com/digitalocean/doctl.Patch=#{version.patch}
      -X github.com/digitalocean/doctl.Label=release
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/doctl"

    generate_completions_from_executable(bin/"doctl", "completion")
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
