class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.8.3.tar.gz"
  sha256 "97dec416e37662674432f51ce4bff5ee38a74d3f1c9c4eebf38097a9be8a4697"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "50f11ecfb25887d7e33cb249b4e769eb2cde37e9b7ac08dbbd8042fae2e539d7" => :high_sierra
    sha256 "2cb541001b66bf3d0d9e9f4d89d6849aa992e9c95904baef1a2f739928337732" => :sierra
    sha256 "85e55190a7f5e5e8ca13398de020cb1e93aa5dcd917b4742a76d907b74d15936" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    mkdir_p buildpath/"src/github.com/digitalocean/"
    ln_sf buildpath, buildpath/"src/github.com/digitalocean/doctl"

    doctl_version = version.to_s.split(/\./)
    base_flag = "-X github.com/digitalocean/doctl"
    ldflags = %W[
      #{base_flag}.Major=#{doctl_version[0]}
      #{base_flag}.Minor=#{doctl_version[1]}
      #{base_flag}.Patch=#{doctl_version[2]}
      #{base_flag}.Label=release
    ].join(" ")
    system "go", "build", "-ldflags", ldflags, "github.com/digitalocean/doctl/cmd/doctl"
    bin.install "doctl"

    (bash_completion/"doctl").write `#{bin}/doctl completion bash`
    (zsh_completion/"doctl").write `#{bin}/doctl completion zsh`
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
