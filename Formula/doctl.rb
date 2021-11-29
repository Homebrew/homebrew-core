class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.67.0.tar.gz"
  sha256 "97c9ee6f28efd621f04ff4bafa269d4f7f6632f5884178f443a22cb610e086a7"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60bac0c13b24ac0d609d48309f1097558279d6d16f5408a83b194ea1f984cb84"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "108e2c7dcd8584626956f213b110af99c6f5bb2a773998f58ea77d3df45862e3"
    sha256 cellar: :any_skip_relocation, monterey:       "afe1274a41e8db9bb426773d749cc5e96254466126e0e5813b6bc158dfd449b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "44846d72f1c5e2de4728736e1ff79c70599ddd922998c274470c4a08e97c82ea"
    sha256 cellar: :any_skip_relocation, catalina:       "20df5d8937d68868ae375fa197dd64af25ab7f88a70643cab1cac271e70df363"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c235dbbf49483325e38b76cb72263ec9301e1a6ffd958ee5d155bfb7024ce2e"
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
