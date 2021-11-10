class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.67.0.tar.gz"
  sha256 "97c9ee6f28efd621f04ff4bafa269d4f7f6632f5884178f443a22cb610e086a7"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1899fe3f2c464a4076d8f8ce0b86679cbf0fc63f08ab306999b7b017dedc940"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b83c9e0141c331fe529e6727af77a5a2376fb2bd7e87814cf32b8b538165b34"
    sha256 cellar: :any_skip_relocation, monterey:       "3b16956084e2f31e779c6af6fec1df675d0333cea402c440cdbb1e32fb57711c"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a4dcca7aacf94403216b841e422caa8078cd8dec7dd2917748df3494544e7b2"
    sha256 cellar: :any_skip_relocation, catalina:       "7a621360fdb1b762452564d1684cc582ce5091dded9dd629e444e9336f5cf973"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6749cf7abbc88b44f0f749767e83464334dec723e12af683f7a709c1bb8f8ac"
  end

  depends_on "go" => :build

  def install
    base_flag = "-X github.com/digitalocean/doctl"
    ldflags = %W[
      #{base_flag}.Major=#{version.major}
      #{base_flag}.Minor=#{version.minor}
      #{base_flag}.Patch=#{version.patch}
      #{base_flag}.Label=release
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/doctl"

    (bash_completion/"doctl").write `#{bin}/doctl completion bash`
    (zsh_completion/"_doctl").write `#{bin}/doctl completion zsh`
    (fish_completion/"doctl.fish").write `#{bin}/doctl completion fish`
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
