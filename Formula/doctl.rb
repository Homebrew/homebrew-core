class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.77.0.tar.gz"
  sha256 "56514dd2d50d74703aef2c184127804e1b08ff2216130125bd066255ebe3220e"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00a10afa317b35a758ca8f448e7194caeac6d4c8baa40bae91020a813304e9e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aee574cd3deb962cabb3cd7c93c26400e3142604bdf9d8623c8aa018d410fbb7"
    sha256 cellar: :any_skip_relocation, monterey:       "152dfcfd02a8e87976075e7bf8a4abe12edd5c558316c5ec92734a87b719d4c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a3bff9956693e2562d065d0c537e1d6317d28f29049ab3a354026f578b92a81"
    sha256 cellar: :any_skip_relocation, catalina:       "f75d2a3c0a36227a9ed147df03fe795c3da62dd1eb6217333e9dbe521b5f233c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "407c185175dbc17e3404726148daf16baed833f5695e21c6e8db8f0204a962f1"
  end

  depends_on "go" => :build

  def install
    base_flag = "-X github.com/digitalocean/doctl"
    ldflags = %W[
      #{base_flag}.Major=#{version.major}
      #{base_flag}.Minor=#{version.minor}
      #{base_flag}.Patch=#{version.patch}
      #{base_flag}.Label=release
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/doctl"

    (bash_completion/"doctl").write `#{bin}/doctl completion bash`
    (zsh_completion/"_doctl").write `#{bin}/doctl completion zsh`
    (fish_completion/"doctl.fish").write `#{bin}/doctl completion fish`
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
