class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.71.0.tar.gz"
  sha256 "62a14c05bd4b8442f0a610f9eba7237fe67e1afc397750893cdf2b741aebfd54"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38ff8eb380adf54840f16b346f07cfef339e57065aac54ed474cf9dde1bd1be8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16a80ceb75a97aa896c53a9afd3dc03badfcd9f0bcffbd52179b196f5944c133"
    sha256 cellar: :any_skip_relocation, monterey:       "87766c760569b86f5050a3eb94bb01b5bd66aa814b2cc5b85005d652050e6fff"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2347ee26d1e9e7082eab370564fd706009d7695b6570b538b73602faef902a4"
    sha256 cellar: :any_skip_relocation, catalina:       "b17a08925d8b86f8003e789a2b61722b5b9d5d95af2e0788e5e48577fbda2809"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f86834dd9a1a937b238a193069b901a435d9d92b3cbefd1dc7661d14619486a2"
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

    (bash_completion/"doctl").write `#{bin}/doctl completion bash`
    (zsh_completion/"_doctl").write `#{bin}/doctl completion zsh`
    (fish_completion/"doctl.fish").write `#{bin}/doctl completion fish`
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
