class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.81.0.tar.gz"
  sha256 "5eb5c7fcb47d623d49b440814d4cfe1294d12119bede851ee7902ed6198ae78b"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "063cf1126e09abb781244f09dd4c64a01281689055d33ea7e2ee97df5305f8ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0dbde6a718c1a17ce4ec1b7a75917c99deb4563746da97d94f85b5b11ef5e930"
    sha256 cellar: :any_skip_relocation, monterey:       "4ed959da5a3852a9b6c7f2140d88fffdaf3181eb5394bac98e86cb679d859357"
    sha256 cellar: :any_skip_relocation, big_sur:        "009d96ee94764fdeb3abafab159764007e6113d42325ed6fbbb5c0e5d943f235"
    sha256 cellar: :any_skip_relocation, catalina:       "1431cb5c79580b37379fb183f556a7cb46af3ee827372f8f06f8d02191c10db6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3540f11360d9217d9dad8532aa09cd251fcd230c7c2f9c1b3a762bce1eaab002"
  end

  depends_on "go" => :build

  def install
    base_flag = "-X github.com/digitalocean/doctl"
    ldflags = %W[
      #{base_flag}.Major=#{version.major}
      #{base_flag}.Minor=#{version.minor}
      #{base_flag}.Patch=#{version.patch}
      #{base_flag}.Label=release
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/doctl"

    generate_completions_from_executable(bin/"doctl", "completion")
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
