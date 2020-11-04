class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.51.0.tar.gz"
  sha256 "dec16ab128c2724eebfeadac05dd4554cd007a57998d3aae3009c71196578760"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "33452988bba4b8bbb94cc288d98b5773cff6376865ab92c720ad1c443d1368ee" => :catalina
    sha256 "1f289202a4a279c6b7f9da4e69667bac40ff23b494e4ba1a475cc0d17e0aa7d6" => :mojave
    sha256 "01811d257f86d3375ab38c375573986f8d299b664976b8e20dead0d2e3821686" => :high_sierra
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
