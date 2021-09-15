class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.64.0.tar.gz"
  sha256 "ad3ff9afac67e6065a602bca783da0d86747a66fde24e542e4947f73b794380b"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "018b0dba263e6e35b089a1a0e3223f45122574c6aa848a73c3f288a9ca40d7b4"
    sha256 cellar: :any_skip_relocation, big_sur:       "12dd6a47099ae90ed410df6fe9b14a53cfa06464121423744cd646a9ef7628e5"
    sha256 cellar: :any_skip_relocation, catalina:      "835594f4124830d4b4dd1d03f06852f49d91e8ff2419bd6ac08e78035c32954d"
    sha256 cellar: :any_skip_relocation, mojave:        "4e431077053da6d575e2f09f9e77c73a2a3e66a7ab63ed53ee30dba6983d0210"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a2db9535cd82a899c0824ee75bddfb5845c2a823941320aaa1afafc0d0f5af0"
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
