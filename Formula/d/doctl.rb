class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://docs.digitalocean.com/reference/doctl/"
  url "https://github.com/digitalocean/doctl/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "b928dce4609de6c1a3b9098792a0ea6dc43d380ba2833fb3e5032410881bce24"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "58c546f20a9463df3af84dd1e791f3dd4f4ccfd20ccd7bafd81e719d331af44c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "58c546f20a9463df3af84dd1e791f3dd4f4ccfd20ccd7bafd81e719d331af44c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "58c546f20a9463df3af84dd1e791f3dd4f4ccfd20ccd7bafd81e719d331af44c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9679e64354534ec3df14edcbf188f35f604fe8d1f9c4bb45096e87c89009eea0"
    sha256 cellar: :any,                 x86_64_linux:      "bbb72f227821451c2d0b5daf4bb7ce0c403b69cf6ef61857faade068a13b9b7c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
