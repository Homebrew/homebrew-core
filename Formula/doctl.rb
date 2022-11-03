class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.85.0.tar.gz"
  sha256 "c71bbf142f4d11039da8f9098f9b5c9bf70502ecf79b3582128f404e521d447f"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d129b495b4a2faf2b787766aee386d9f90c69e2858d1f75a4b84fd9cf014498"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be574f207245e1b87e0730ef5ab83e1e4657eb6ee13a892d729ddeb8f1d4008a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "62cddc8cdde45edee72761adb9b47c28b015e642090e8a953688123d778ba3e3"
    sha256 cellar: :any_skip_relocation, monterey:       "f84e326b8e88912cf01b8447357e08edd989e4628149eeb84628e93f93116bfd"
    sha256 cellar: :any_skip_relocation, big_sur:        "bed07af29f6f67a5c5262c5e759b3dd7e1714030e0ee5be574b969c05f0fee80"
    sha256 cellar: :any_skip_relocation, catalina:       "b8ae4da3c68f5b79e4a2326b96afc68822fa3b91b10c43e43fec1b1613857546"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d428332969991494e0d861a7c259f9a54732e215f6b29ee498080a0c9e1b5902"
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
