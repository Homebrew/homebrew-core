class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/refs/tags/v1.160.1.tar.gz"
  sha256 "743635d7c2e29e5912020e980654cc168557cb43f2ef6d0b3057900efbe13f23"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f7abe9fbf8570d5111eaa832dc0fd3fa8d5ac1be2b81b3fcdc436b094b7d44f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f7abe9fbf8570d5111eaa832dc0fd3fa8d5ac1be2b81b3fcdc436b094b7d44f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f7abe9fbf8570d5111eaa832dc0fd3fa8d5ac1be2b81b3fcdc436b094b7d44f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cb8133230e78e594f96d53403cfccfc8038a41a0d1885ee166c7db292d37ef7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "178342ece7214828d9c795d326fadf48396da8fb3882b6bf85e2bc8aef0e3d5f"
    sha256 cellar: :any,                 x86_64_linux:  "ac85fca62b712bb9a822f14ce14d96958930b456324d4c7c6e55bb6edee26454"
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

    generate_completions_from_executable(bin/"doctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
