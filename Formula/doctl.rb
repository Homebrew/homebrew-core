class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.88.0.tar.gz"
  sha256 "3676f3e56583aad159e7bfbbaab3fb2787e034e15a8587b22069053c759b0d06"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f5cd709be76af891837d410efd212d8463ea0e23b85fc53396d75129647074f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e84efb1407934eba796ca31bec2f7782c7daa9ea9e8da2cdd790fcdce20c306"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b9a562fb18dde076eb5d8dbc01b028a01e4d18aa878a9c3473521dc130a65bd"
    sha256 cellar: :any_skip_relocation, ventura:        "08fa03019c07a3ee314db4a484969a4d9bf0c72d847f4514250f8b848584e96f"
    sha256 cellar: :any_skip_relocation, monterey:       "06f55de5c47fd78288a1b650cc857b67d06b0b55899f5236154d88b216e21153"
    sha256 cellar: :any_skip_relocation, big_sur:        "a0684d73ecfc93db891cde4e2da41b948f20eb828c2a633925e52bb5301e3838"
    sha256 cellar: :any_skip_relocation, catalina:       "61532b177c6bcb8f37f7b862fb32a3d8146745c92ccd0a4696a97a75cfbda76a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d44be90f649b120fd2d337af4cf5e03d8513eb1e06b4a92f751838073959a69b"
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
