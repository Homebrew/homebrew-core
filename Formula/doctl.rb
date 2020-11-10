class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.52.0.tar.gz"
  sha256 "e4a0a08d5be545b9bb035ed377c0b7e7705e217bf55d4f4423d7dc8afb0a5819"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ab02daf972403a8f59066bd88f86797ebac3357330743b1fa7705969ef71dcf6" => :catalina
    sha256 "b05021938d7b7a121257cab476f703b105ec7334b6d0929816193aabe2f52a53" => :mojave
    sha256 "471f81ec8f53fe3d6f921426069b36fbd93247544ac589f383c3889681247e1e" => :high_sierra
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
