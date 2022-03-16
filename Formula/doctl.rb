class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.71.1.tar.gz"
  sha256 "53b21969367fc4c891c8ae17f2ca167414aa7be1a3f566ff6ff240acd8bafb85"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e0bba29801fe489ae24a4a91b31ffe214226fad1077618b7e4426d2781ed6e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0bd63ff07ea54e37dbc13484f0712219a6dc80b3b5bd79a7c5ea232e64bc03b"
    sha256 cellar: :any_skip_relocation, monterey:       "12c2dbbd07f350ac7cca39ebd2a8f50fd721546f488e7ba94051a17c2c8885f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "e50f12562d19cc80d5290c8d17803470913e387bb879ff9091e09d6218536d4d"
    sha256 cellar: :any_skip_relocation, catalina:       "e901c0246406034f9bf66f65365242b929cfefa2c8a01dc33918f717219eb385"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f03ba48bb5d2e99b179515defddeb3f5a53737f6c80d82004ca191427128e68"
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
