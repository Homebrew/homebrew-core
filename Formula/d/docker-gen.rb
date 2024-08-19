class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/nginx-proxy/docker-gen"
  url "https://github.com/nginx-proxy/docker-gen/archive/refs/tags/0.14.1.tar.gz"
  sha256 "6e9363ce91a2cfb4396cbe7583728a8df0e5fddb03c10d0b8aaa426a93cf075a"
  license "MIT"
  head "https://github.com/nginx-proxy/docker-gen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "10aa250ccacf12af0586cdb26e12d20291bfb93840db037c7ac20c5d54dd5e17"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d3c813e2d50f109f8664f3744f53209df731d3e5a7984e028efdf5082b38eb7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30a5c1029168e2e3d4a265ec7cae38bebe8d0eb712f2579b146d9fb0c07c806a"
    sha256 cellar: :any_skip_relocation, sonoma:         "b87ed5d29ae98d03caaf00c8f8234de932146a2cf892d950de101c26af627c5d"
    sha256 cellar: :any_skip_relocation, ventura:        "f62b93fb5c5763aa5137459bb9690424a35bb926331d8edf21312cfc52785da5"
    sha256 cellar: :any_skip_relocation, monterey:       "e1f5b42598fa8a7424ae4a377098e5fde6e71686d694a6b99636e09e517c55d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91fdbc3850fdf5730b0d58946aac46bf735e85ac64a1b3422c77b0206b05f10f"
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
