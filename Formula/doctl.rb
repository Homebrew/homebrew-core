class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.56.0.tar.gz"
  sha256 "1b566c84cff43c5dd31c13a2491c80decc8722d4119d219c5e09be783f544356"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fb30620d20e02424f3d32eca26ebdcb534d6d53dc60bd96e6cc85a179520c0af"
    sha256 cellar: :any_skip_relocation, big_sur:       "4c036f014fb65c082b1addb3fd813808c2107c729d472fa532df6bee9fdb8eb3"
    sha256 cellar: :any_skip_relocation, catalina:      "e9b9ae8cfcf94158de15defc2009dc6974dd579d15a1ed18de20d9f9714978bb"
    sha256 cellar: :any_skip_relocation, mojave:        "c1c76d3dc5d6afaf9f70f1d96257a14606e20295d6e0a6d545139f74eeba83fb"
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

    system "go", "build", "-ldflags", ldflags, *std_go_args, "github.com/digitalocean/doctl/cmd/doctl"

    (bash_completion/"doctl").write `#{bin}/doctl completion bash`
    (zsh_completion/"_doctl").write `#{bin}/doctl completion zsh`
    (fish_completion/"doctl.fish").write `#{bin}/doctl completion fish`
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
