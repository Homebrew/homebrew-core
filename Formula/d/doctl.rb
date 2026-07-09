class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://docs.digitalocean.com/reference/doctl/"
  url "https://github.com/digitalocean/doctl/archive/refs/tags/v1.163.0.tar.gz"
  sha256 "8cc7acd78114eea8409f86b11843d1298d9b12cc984c277f594802acbb3c972a"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "118fdcd776117b2f389073b86fc9b4948d81732aa6324eb37d0f19e4e899d88d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "118fdcd776117b2f389073b86fc9b4948d81732aa6324eb37d0f19e4e899d88d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "118fdcd776117b2f389073b86fc9b4948d81732aa6324eb37d0f19e4e899d88d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1019c8a88266f6c3136e264f68df890be9650cb312b43926c5faacdef5befe17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "adb2d7d45974092d3f9c11447d51b81635933120450c17243ac6a6269f1c8b62"
    sha256 cellar: :any,                 x86_64_linux:  "596119759db16d8cbd9f103e8b28c297f97c730131dc499e745df8c1a0aebd67"
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
