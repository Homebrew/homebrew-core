class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.59.0.tar.gz"
  sha256 "b37b693635af48da8b2b222486be3e315e9ba6eb8fdb0b0e976bff1e63f9c520"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "32fd34d3e2c2dd26f546fbd8fb869ad70099a027823218fcb8389af24d879a66"
    sha256 cellar: :any_skip_relocation, big_sur:       "2d2d20f80a9e7eed3a8743a5d7b27d46850ce962ef04049bdf1c4fe910feebff"
    sha256 cellar: :any_skip_relocation, catalina:      "c2f30e944eb83e503fce928a81f1ccff205887391794fd59330cde4dcdcd2d23"
    sha256 cellar: :any_skip_relocation, mojave:        "f0284616b4931f6d4825d29399ea8268dd4b93e743be00a2dd76a2ee8e7ee5e8"
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
