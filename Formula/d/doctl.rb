class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.98.1.tar.gz"
  sha256 "1985bc8197573016c6937283310aee0d498b04121fbab8ec2a84a5f9b3423130"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1eebd5d131167b0977a851f683021872b1e59e53acff48021543ef4ba80f0352"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5029d1f263c64d03def606685b3a7231ec5911c698ebe69278dae7b6d79bf93a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29a2530bef91eaeaa9db63329a0eb3a1ae2616fa88f2115d64946a8eb199db9c"
    sha256 cellar: :any_skip_relocation, ventura:        "85d2cd5f10d9faa79f056833e58da50395195bac4cfe2bda6562e3984b8c5d86"
    sha256 cellar: :any_skip_relocation, monterey:       "8680cdbfbcc2e6000f9ea29311194ded2d12b67f8e87d25fdf15b7e6c717d116"
    sha256 cellar: :any_skip_relocation, big_sur:        "90ab7147f333868d8f9ee2cb4e3987242f390276c262e87d4c673ef480d00223"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "634a9f820633c5c245e8c7820377f46d1bebd02825b9fbc347da68eb6c16efbb"
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
