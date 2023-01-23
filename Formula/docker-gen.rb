class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/nginx-proxy/docker-gen"
  url "https://github.com/nginx-proxy/docker-gen/archive/0.9.4.tar.gz"
  sha256 "4c25f9a876d90710586fce38ec18336fc9b679e5a6237df458f5674ca82b3d8b"
  license "MIT"
  head "https://github.com/nginx-proxy/docker-gen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ac39032a9c328a057df2ab83001bf608f0a84dad141baeadd3b224f03e919e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1d85ec311cf50e4da40100e8d19d89af9c0742fab3bfc8ceffe508c2c8c106d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "901ac74aa43242f333ab0dae5bf1cd9429d0f7225a98c7f289eb89cdbe514a33"
    sha256 cellar: :any_skip_relocation, ventura:        "ae494039bc66e3c17f925c89a1a5ec3eadd6772fc63c11fb24eb883a305c31f1"
    sha256 cellar: :any_skip_relocation, monterey:       "91b5d206ba87d1252339342a2adc84534ef70979038d548dd3a0099ae35d135f"
    sha256 cellar: :any_skip_relocation, big_sur:        "734bfa523c99a266ea56bb3913f71ecc015548a12dcdb0ed0907e99bd64df5cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dae292734a9d2812d23b3fd78073681f8050470b1957b447b4ca9ceb9e1df3a5"
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
