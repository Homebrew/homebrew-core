class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://docs.digitalocean.com/reference/doctl/"
  url "https://github.com/digitalocean/doctl/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "4bb2de68b803d8cfd1343f64ed39d56788209947d37074f17d59d89ed31364fd"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    manifest_sha256 "7884b1165282927de452a1d20c7c67c524dd44cf3ffcd39c788621b733894a33"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "80a49e43dd4588c4a86aa4d3b2a7cad3960b8c728a8630322a793b8ad271e742"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "80a49e43dd4588c4a86aa4d3b2a7cad3960b8c728a8630322a793b8ad271e742"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "80a49e43dd4588c4a86aa4d3b2a7cad3960b8c728a8630322a793b8ad271e742"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b07a4c99980e0fa33f00d3d0f5e884a7434013e7737dcece951f0ad78b66cf43"
    sha256 cellar: :any,                 x86_64_linux:      "672ffc6ea5026571ae872d820dbfa05759973a5d8fe1ff8f918062e661f8f9f6"
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
