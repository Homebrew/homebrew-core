class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.98.0.tar.gz"
  sha256 "3a59fb478928d8c82743b12f664a598b1e917b348cbb524c412ce6b46e9f8ce2"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1ecc67ad6f480dd5775181c65c181e0f107969090cb2f46efe337a1d1128751"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f25913f04e6b34ae09dd62ba9eeff3506e4ee3f17fe4f3d211284b753144d90"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c2337413cc4a67355017f1b9c5e75fac1d855cbc000c349788d8a32d095179d9"
    sha256 cellar: :any_skip_relocation, ventura:        "271adb5b36fece91f9d0a58eb67d4b5d4bc99fc7fe8d7f4aaee054029df3ad37"
    sha256 cellar: :any_skip_relocation, monterey:       "83a01b9e40badaa162c044e59079a6a0f25cf66f1047bb0989943b2d4d588ea7"
    sha256 cellar: :any_skip_relocation, big_sur:        "25419df93bd3b88aee47110466ad4f36227e8da42d3ac7e21e41cf5bfbade1fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7155728f9566119d94b020ac9a0f42f36c90958b2f5eeed8d0e5b90ec066f2b"
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

    generate_completions_from_executable(bin/"doctl", "completion")
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
