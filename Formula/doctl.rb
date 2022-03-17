class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.71.1.tar.gz"
  sha256 "53b21969367fc4c891c8ae17f2ca167414aa7be1a3f566ff6ff240acd8bafb85"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "999885830979603efb7c44d8cfb9bd5d518564a8aa1f9478d999b04456ebc507"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca78547c49334b0462bb458da2013bd78bddccff365c46baa6eb0cc94c866ad1"
    sha256 cellar: :any_skip_relocation, monterey:       "a19a7d33db797271fa30699f67fc014858215a56cc4334cdc8a37cc25f528627"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc41631e50c71a18983a04140966f9be5b38edb404447de71e72fc7095a5f588"
    sha256 cellar: :any_skip_relocation, catalina:       "de9b9ec129081c2ac1213c70a6c235d3245a962d918ef6ca58ab033029fd656d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "510de555df3cad34735b8feb8b7255c6fcbdd2df60853d7ba96aede2dfad2dfd"
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
