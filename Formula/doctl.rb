class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.12.0.tar.gz"
  sha256 "15b0cf0dde2ad3cd14b0f5d6a61e84d8497ceb0a0d6981024b2298ab3c99869c"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1fd8be2d90b0033aec6f159c92a0a5ea38848c66ddd426e853a6af4bc9afa4bc" => :mojave
    sha256 "0cbb5e0dbc42e0832348643df42451352a3a378419a6570bd2662e9f54e70437" => :high_sierra
    sha256 "13e52a21fd86a1f042e3ae5b9d203558e4d9738a181f0ecc8bde4c1f7ca96dff" => :sierra
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
