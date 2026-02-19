class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/nginx-proxy/docker-gen"
  url "https://github.com/nginx-proxy/docker-gen/archive/refs/tags/0.16.2.tar.gz"
  sha256 "22a8a6a647fb5e405abbc904f6453145ead1905c335ec5f6832a1e02c32f63c7"
  license "MIT"
  head "https://github.com/nginx-proxy/docker-gen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4788abb89cac4c67bdb00d4e36f0a4e99f92e2af5a495d0ca585086cadf46a5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4788abb89cac4c67bdb00d4e36f0a4e99f92e2af5a495d0ca585086cadf46a5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4788abb89cac4c67bdb00d4e36f0a4e99f92e2af5a495d0ca585086cadf46a5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "1243875666b91b334b8e68d2ccb902216dba1cf37cfbd4d671c014b3a780f260"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9d08d30eee0f19c1d87bbb07defa3b86d74069fd1a7905535ef0a36817f5824"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3c3799499f4f3283d76d098d1268e7c30cf38ab0a6019fb6fbee859037f2de6"
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
