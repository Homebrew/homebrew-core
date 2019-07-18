class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.22.0.tar.gz"
  sha256 "714a3bccbe67e18b5658eb26112551bc34cc876db3eef58c8aa1bdb603b7ed5f"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "61e41bcd902927241ad42f9cdc993e6c807b64a63fe73e9a3594991a9cbfdbab" => :mojave
    sha256 "dbe5d3894f66855bab0379a5dd5079c698b21339fcbf5f6e1c664e4afff3b403" => :high_sierra
    sha256 "0c2116bae4e8a01b174804a578c4e637e8551d3a95779afb6c39b51316d826df" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"
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
    (zsh_completion/"doctl").write `#{bin}/doctl completion zsh`
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
