class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/nginx-proxy/docker-gen"
  url "https://github.com/nginx-proxy/docker-gen/archive/refs/tags/0.16.4.tar.gz"
  sha256 "4c2c730f88b46a2543368f767ad12498959d64fd9e144c50872f53631b449687"
  license "MIT"
  head "https://github.com/nginx-proxy/docker-gen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8f53c474ec60c4944568c60e53ca63a8c87d88cdd8359c2d241b8cbeec3aa77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8f53c474ec60c4944568c60e53ca63a8c87d88cdd8359c2d241b8cbeec3aa77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8f53c474ec60c4944568c60e53ca63a8c87d88cdd8359c2d241b8cbeec3aa77"
    sha256 cellar: :any_skip_relocation, sonoma:        "a59478f279c13c41e0417546ef81a46e86ec115578238214c5341859a8fc432f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aefb2f17ea8e7d7049d2326cee45aca1ae015309d3802939bd3130510254e287"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b44fc7dacfa7e3ce54372ea2a4af9d0484a911136ebe4c1c8ca1597aabcdaec3"
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
