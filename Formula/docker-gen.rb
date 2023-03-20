class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/nginx-proxy/docker-gen"
  url "https://github.com/nginx-proxy/docker-gen/archive/0.10.1.tar.gz"
  sha256 "46cf159194514d4071a945fd04b5c3c4e04eadae27efe92c97f52dd026f7d903"
  license "MIT"
  head "https://github.com/nginx-proxy/docker-gen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d518300f12f1d9b7a077e94616fc9d8adda28d9e56072ff57123f7903d876b11"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d518300f12f1d9b7a077e94616fc9d8adda28d9e56072ff57123f7903d876b11"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d518300f12f1d9b7a077e94616fc9d8adda28d9e56072ff57123f7903d876b11"
    sha256 cellar: :any_skip_relocation, ventura:        "f8592de312f25d0e7b1afad832e44f053d3f9b9b65e6ce6e915975d89bb0b379"
    sha256 cellar: :any_skip_relocation, monterey:       "f8592de312f25d0e7b1afad832e44f053d3f9b9b65e6ce6e915975d89bb0b379"
    sha256 cellar: :any_skip_relocation, big_sur:        "f8592de312f25d0e7b1afad832e44f053d3f9b9b65e6ce6e915975d89bb0b379"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fb82ba3ff554bed39e187f6d27cae9bb6d8fad56c4bb4fb9d1935ec2e6891b9"
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
