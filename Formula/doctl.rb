class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.73.0.tar.gz"
  sha256 "cc7a6f91febf4d40f8afca0fe4ddfa7aa9be3572e3a0124fca2865e35b52ef00"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d5e641d2447ab70303144a5bca8247d356ae255cd5682b7f93a5da665a42539"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef53e332c57dd127a3c4f9877ec8a1c69b63107c5b03df8a336cc026f447f19c"
    sha256 cellar: :any_skip_relocation, monterey:       "193ccac317506a2c94271365db89e46f708de084373c6ca9a1222a8b7b571b6f"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c34774cff1d169e3e7ed455b96adb782c0f66bc63f6866bafe7b9acc8d34df5"
    sha256 cellar: :any_skip_relocation, catalina:       "aeaa4a79cd0e9aec237bf9b91de40844a73c0820983613d4fc06c17e34996558"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4863dbefb13f3d6ca0f349f576c8c79ceec2924d4d38d7279fbd7a470c079f79"
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
