class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/nginx-proxy/docker-gen"
  url "https://github.com/nginx-proxy/docker-gen/archive/refs/tags/0.16.3.tar.gz"
  sha256 "086956d86d7687575a24dd532988d63580682660e4050e19ed89125e210dd307"
  license "MIT"
  head "https://github.com/nginx-proxy/docker-gen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "730d3972ec65ea77b695c46145c521d9b46b4dc0b13111cd0f218c6332c023e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "730d3972ec65ea77b695c46145c521d9b46b4dc0b13111cd0f218c6332c023e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "730d3972ec65ea77b695c46145c521d9b46b4dc0b13111cd0f218c6332c023e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "83f7bd6ffa371c44f2f605d333fff4b2f29d3346b54cd64fac6b1a1247b28f6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d51c1ad0fe18acaa72de38a8a3122e4f83c918560deb957d8af314d8dd75ad50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f9862e81d0930ce3ab8bcbd52ccbfcd40e65ae847d011583ac785225b612d31"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/docker-gen"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docker-gen --version")
  end
end
