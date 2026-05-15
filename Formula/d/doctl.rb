class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/refs/tags/v1.159.0.tar.gz"
  sha256 "9710b60ce38cdcd1b1354fe349a2c01c319f84f581ec03722320d49cfc2af66e"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27bcccd0b550c6fee137918250ef6224f5f6ccaf1d9766eb76819d413686db88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27bcccd0b550c6fee137918250ef6224f5f6ccaf1d9766eb76819d413686db88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27bcccd0b550c6fee137918250ef6224f5f6ccaf1d9766eb76819d413686db88"
    sha256 cellar: :any_skip_relocation, sonoma:        "abeec73e560dcda57b527c826b0d70a213c7ea401d271de5ef475167b9627802"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eda1ed553713d265e02f1a9a8dba29f276bbcd97441e55bdb58e23610f6511b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94ed618e12409204a1f8e99bbc2ef8395faf2b1f0f025fe26c7f92adaa115b38"
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
