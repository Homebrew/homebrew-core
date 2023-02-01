class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.92.1.tar.gz"
  sha256 "4d1b53ee473f4320fbbd834d364497acc31ba5dd5a4504d71c8b9eecfe9d76d6"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b70c76dfc3c24fa7d76eeaecb0016b48bf49b686a490817cc83a7eec8ebd6e8d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23872d65a3dabea23a1988409853a9673b4c37b902cf825532658700dc03707c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b11c923d8140849c22a858b26a84a2de5718f4f7c5687f80eec58c76fb00443"
    sha256 cellar: :any_skip_relocation, ventura:        "34fb0702c7a086f9cf69d4e125262b6f17531c2b2ba4fa75a2af44b295f20649"
    sha256 cellar: :any_skip_relocation, monterey:       "2a53bd988c8dd0f17d6d9f52eaf13c6638e7cff5b60e420986b00192a34b95c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "707649c430e12f6d2a5b00935c2828b360786ff1803c1087031575ee7deddb80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ac8fd5ce63843903469c12e51470b09e376e18fd37a8547c6548aa6b6424455"
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
