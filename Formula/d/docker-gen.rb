class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/nginx-proxy/docker-gen"
  url "https://github.com/nginx-proxy/docker-gen/archive/refs/tags/0.14.2.tar.gz"
  sha256 "52ae0f2e299a505dfc92fee79dd34ed5efa91c132bf2adfb52e607f93e4776ea"
  license "MIT"
  head "https://github.com/nginx-proxy/docker-gen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "131be5f9e2c6405541879cc631100d8f878d4c69089d15d5b0d8287657f3681c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3ebd783c3f9b779a5146fb28169b037b0a1a817f59a188daa635948a5ea9d566"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ebd783c3f9b779a5146fb28169b037b0a1a817f59a188daa635948a5ea9d566"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ebd783c3f9b779a5146fb28169b037b0a1a817f59a188daa635948a5ea9d566"
    sha256 cellar: :any_skip_relocation, sonoma:         "6aa979c284a09ade1649a92510b91f969ca168ae9ba92bc49dda40907c4635d0"
    sha256 cellar: :any_skip_relocation, ventura:        "6aa979c284a09ade1649a92510b91f969ca168ae9ba92bc49dda40907c4635d0"
    sha256 cellar: :any_skip_relocation, monterey:       "6aa979c284a09ade1649a92510b91f969ca168ae9ba92bc49dda40907c4635d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72b8ac70c979b61d11d27afdcea378c1f0c9e38c0d8275e6504bac74a2776728"
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
