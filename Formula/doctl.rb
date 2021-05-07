class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.60.0.tar.gz"
  sha256 "3bc9cf89d530e3a665334403f4329a011da1eb216343d4ee95c4a66075eabba5"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "079a0102d1c50dcfe550a8b55325f129663fa571ea203c75b1cd0db4f7a1e730"
    sha256 cellar: :any_skip_relocation, big_sur:       "57e68cd6e109740b9b6e8ff432cf55f507cc8993cd9800a0511e7e486a2a452a"
    sha256 cellar: :any_skip_relocation, catalina:      "b762af03b7e7ae10cf83968f4f29582861462de7eec7e61fe0b311f45dc75ca0"
    sha256 cellar: :any_skip_relocation, mojave:        "6da77128cc1bc907ce0dcbea103601b228201b3564c60c7a0e82590a08e1c316"
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
