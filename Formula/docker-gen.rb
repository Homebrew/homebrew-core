class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/nginx-proxy/docker-gen"
  url "https://github.com/nginx-proxy/docker-gen/archive/0.10.1.tar.gz"
  sha256 "46cf159194514d4071a945fd04b5c3c4e04eadae27efe92c97f52dd026f7d903"
  license "MIT"
  head "https://github.com/nginx-proxy/docker-gen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d47a47ae032488f916238eeede322dc8bd72df4ac54e65b5222aa358774d583"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c853155cb8be3f81485c6cc7a943daadcf8ffdeb50ff830893a4279970ab3f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f2dbbd6263a8c0dc48fa87b1b3ce6233251c036a1e6598e49f8b0bc85f9055b"
    sha256 cellar: :any_skip_relocation, ventura:        "e3ccc7feee447cde08f69a285c6b2584f7b0b013de2283c42ea980cbd08aafe8"
    sha256 cellar: :any_skip_relocation, monterey:       "c61f30a45558913c4d59099084bb3a60e0a67f069d81a0a7963904a76fbaa2a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "0459fe3dedec4e9f4676d324698d6c683d2235c473a4cb3eb5f32be4f2a70420"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d33c9a46dd56ef825fe7b8a0ae59da1925e069ef41cbf0729fafe2ffb76d221"
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
