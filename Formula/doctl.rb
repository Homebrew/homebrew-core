class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.53.0.tar.gz"
  sha256 "f36ea283d7be9d1f77c69b1f60eda64d83aea5995f55f16171683f58897ad19b"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "88d88c4c5a450bda48b2cfdf778b3c10f8150d0ff1e761c12f448eda60444fb1" => :big_sur
    sha256 "a48b656b6e4ecba3aa74672fae20ba7ec59320a2eef5c4d9df3f68f89c5cd417" => :catalina
    sha256 "314cb1e5cdbf6d560c4cc971822e2fc0e63d7ab03e2d37103b2e8bbf30a76946" => :mojave
    sha256 "de1fbd938c182c41265bd624cf30dfa75c13e054ae9677d700bb53a007e44927" => :high_sierra
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
