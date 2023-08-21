class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/nginx-proxy/docker-gen"
  url "https://github.com/nginx-proxy/docker-gen/archive/0.10.6.tar.gz"
  sha256 "bb8207cf194bfeba0a92ba7f2215fd039ebc0d5d3730d3d2403f47419d67c957"
  license "MIT"
  head "https://github.com/nginx-proxy/docker-gen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "846dacd97e7d5e3cc9a6fe3ee82ffa4ef03561bd222c9afff19cae51aece4725"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "846dacd97e7d5e3cc9a6fe3ee82ffa4ef03561bd222c9afff19cae51aece4725"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "846dacd97e7d5e3cc9a6fe3ee82ffa4ef03561bd222c9afff19cae51aece4725"
    sha256 cellar: :any_skip_relocation, ventura:        "3633fff4ff83cdf232b6f9018cb6f3fd237a83a333a970766b08d4b8ef539402"
    sha256 cellar: :any_skip_relocation, monterey:       "3633fff4ff83cdf232b6f9018cb6f3fd237a83a333a970766b08d4b8ef539402"
    sha256 cellar: :any_skip_relocation, big_sur:        "3633fff4ff83cdf232b6f9018cb6f3fd237a83a333a970766b08d4b8ef539402"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22fa57371ee73306de9f77e993d3430fb786630844b3f150b04525935b420b3e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/docker-gen"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docker-gen --version")
  end
end
