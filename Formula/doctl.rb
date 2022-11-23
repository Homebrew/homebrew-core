class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.88.0.tar.gz"
  sha256 "3676f3e56583aad159e7bfbbaab3fb2787e034e15a8587b22069053c759b0d06"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fedbfe0ad955fcd758a070219414e7767024175e2c8b1978350d16627743c93b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "affaf708f99e48af3fac8ac38daf07f9b8b6031957625369518d1ef5146d5d2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce5b6269d4fb989c87bc5cea0c64c697d2bea73ce80dbb9d6273dfb5e168628f"
    sha256 cellar: :any_skip_relocation, ventura:        "2e2ddc5b1295aab324f1f333fa2aa67155f606ab2db96b32d586bede119b27d0"
    sha256 cellar: :any_skip_relocation, monterey:       "213fed54a4e70b06dc7d0836692d382774fc0a9f627d3ef989b37cb692ff55a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a0b96f3301da95cf357d2cdf8056ad7475a93cd579ed644efe5c8af3a4ec0dd"
    sha256 cellar: :any_skip_relocation, catalina:       "a89b6e0a18b674a2e8f49b43e25d9b34a99f728444485556f14bb1969c58f801"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0199d4307cf55532d30ad91c25c1ada0eec18574905553d96854cb46c382cd1b"
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
