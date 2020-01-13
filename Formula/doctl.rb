class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.37.0.tar.gz"
  sha256 "acd34035c3ec604ae4266bdf468d8b7644d6e13701dccc739a89a7a896a029bb"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d966661d8aab25154603d21367132ed8bfbdc12663982db8582737b72c7b31b5" => :catalina
    sha256 "d20263437bbd26c0291428912f23af33d37a8be2ad702678f611ce63512d1160" => :mojave
    sha256 "ebd3da967ca1c994936347aeb9859674bd4d8c6a047ca710008cb42f3933006e" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    doctl_version = version.to_s.split(/\./)

    src = buildpath/"src/github.com/digitalocean/doctl"
    src.install buildpath.children
    src.cd do
      base_flag = "-X github.com/digitalocean/doctl"
      ldflags = %W[
        #{base_flag}.Major=#{doctl_version[0]}
        #{base_flag}.Minor=#{doctl_version[1]}
        #{base_flag}.Patch=#{doctl_version[2]}
        #{base_flag}.Label=release
      ].join(" ")
      system "go", "build", "-ldflags", ldflags, "-o", bin/"doctl", "github.com/digitalocean/doctl/cmd/doctl"
    end

    (bash_completion/"doctl").write `#{bin}/doctl completion bash`
    (zsh_completion/"_doctl").write `#{bin}/doctl completion zsh`
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
