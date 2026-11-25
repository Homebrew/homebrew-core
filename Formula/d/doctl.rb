class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://docs.digitalocean.com/reference/doctl/"
  url "https://github.com/digitalocean/doctl/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "ea902efc3f02f75af78424ff76b12b422efbf4da13c018f54420a73712bfe6b1"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    manifest_sha256 "1098f45be886a5a2b4886a0734a7fa70aeb065a6c52cd0b452cb835e897df955"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5ae3c8d3d4ee6f61e601f6cb6af6db67a495ff2120f8ac47885f4b6e239d9b0b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5ae3c8d3d4ee6f61e601f6cb6af6db67a495ff2120f8ac47885f4b6e239d9b0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5ae3c8d3d4ee6f61e601f6cb6af6db67a495ff2120f8ac47885f4b6e239d9b0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5c08a45af7118f92c1c8ed21321755afc5023b84fe8615ca920e9e97c78f875a"
    sha256 cellar: :any,                 x86_64_linux:      "0616ac505ab4b1e0fa2e170494315633a30b680a7f11cff0896f8f74f676510b"
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
