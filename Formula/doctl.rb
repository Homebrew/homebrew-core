class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.83.0.tar.gz"
  sha256 "43e5d76715b7627374c00fa83a3a53726bc8735ac8b86a3960de133608a84eeb"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f87a205427832dea2619d0d6f0539960190ee40695454dcd29353cd4082b8c6d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d966dc78b0eacc167b49775145082c00c16bb2f62c830170188a718dd12963a2"
    sha256 cellar: :any_skip_relocation, monterey:       "daa2e4e7b2f4aa043cf954b0c1cd85385fb228ffe70be06a405e00c127ec2b51"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8f5a4f2c493c91d91916fefeefee2ae7f84b010d8200f2cdf14bcc8a247aefe"
    sha256 cellar: :any_skip_relocation, catalina:       "05d3276ac1160f1885a7f740af7a3f619421b7f5c03507e46b6fe6c7b4e04bcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "368df8d11047ed8b813a1c6c8139f8cbe0e15356cc075aeb543a631e646afc61"
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
