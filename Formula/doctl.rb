class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.17.0.tar.gz"
  sha256 "a366df78421951edc897d95914cb23ed36f633c46bbc6cb90e230180e7119a33"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a81286aa76b8c9dccdf87d29aa6c01bd1c432d2cdcab36ec40f45ed0d849db2d" => :mojave
    sha256 "57ff00aec86e55272ecd009262e8a40bc742bb30a8ce391a372a8ab8ddfc24f1" => :high_sierra
    sha256 "d9bb4e30282234ff5d756bcd364371fbe6cb44e0ceb6dd8b80a7009d7bc61c8d" => :sierra
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
