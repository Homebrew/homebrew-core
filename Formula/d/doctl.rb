class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/refs/tags/v1.120.2.tar.gz"
  sha256 "9fe4d2d2291d25ca56047d049dc6835f32f55700176fdf8a6c1db885e7764239"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a81fc58aba417f3217ff6780f37bb9d6ce37ec5b9507158fa3f454e69fc22e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a81fc58aba417f3217ff6780f37bb9d6ce37ec5b9507158fa3f454e69fc22e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7a81fc58aba417f3217ff6780f37bb9d6ce37ec5b9507158fa3f454e69fc22e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ff1eaba767dd0e485784f7190df3eb8106ad7d2281f03291998b12e862327a2"
    sha256 cellar: :any_skip_relocation, ventura:       "1ff1eaba767dd0e485784f7190df3eb8106ad7d2281f03291998b12e862327a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "221ece416e0c0526c28501dc7cda5a31499d2f8792fec8cb094241db63551f70"
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
