class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.46.0.tar.gz"
  sha256 "f283df1860afa47551da24c9c0d0ebb1ae4535c7a69e62507e4f787ff47cda60"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7ee6001d0ee0c2325d6047be50c8a27c347c25dffbd099c4fd00bd8462583c01" => :catalina
    sha256 "2e59a7611adcb85c8052825c8920b06d6b942e30872dd0dd2670ec99e3cdf8ad" => :mojave
    sha256 "452c701712149cba126413d035aba3fbe293c210c731c10667a7a258c22ce995" => :high_sierra
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
