class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.60.0.tar.gz"
  sha256 "3bc9cf89d530e3a665334403f4329a011da1eb216343d4ee95c4a66075eabba5"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2042381ba5a27e324afd1a89dd112c6bf03d34686ff068791b7cba54b719d7f4"
    sha256 cellar: :any_skip_relocation, big_sur:       "d59eb0a5b689c19dddae52012e737488b7fc8241f4299d79e1c4ff2aff46f135"
    sha256 cellar: :any_skip_relocation, catalina:      "4bea70ed6f96e5746e8abe67386fae1dae7707243df27d1dd4e41d35576684a7"
    sha256 cellar: :any_skip_relocation, mojave:        "559bdefd9adc7aa5d303df95daf1cdd7514fc80fda95ade2f92048c14281a5d7"
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
