class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/refs/tags/v1.145.0.tar.gz"
  sha256 "6a7ad2e90f635358dd3ddf1fc738e267925bb2506f7beb4c222a265b31ba585c"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53d623269858cd34032ba204e9e435af3466e85f5a11c0591d41441f28725d62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53d623269858cd34032ba204e9e435af3466e85f5a11c0591d41441f28725d62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53d623269858cd34032ba204e9e435af3466e85f5a11c0591d41441f28725d62"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e5b205764362531845e7065680d407e94d8b3e1f4adffa9284dc40fa9194d5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a0eec904f64cb70ae9543c37d5d7d7d9242a144385b26ea4af1a72e85ddb455"
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
