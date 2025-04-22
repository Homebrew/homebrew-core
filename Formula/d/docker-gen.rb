class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/nginx-proxy/docker-gen"
  url "https://github.com/nginx-proxy/docker-gen/archive/refs/tags/0.14.6.tar.gz"
  sha256 "bebdebef78196a5af2c49471116bca007117015d457d9279bff4d5f8fc95417d"
  license "MIT"
  head "https://github.com/nginx-proxy/docker-gen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4183b4b5a4f1fbc43e956a0bdc1b4fc71291868bf81428472e5f750676e1108f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4183b4b5a4f1fbc43e956a0bdc1b4fc71291868bf81428472e5f750676e1108f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4183b4b5a4f1fbc43e956a0bdc1b4fc71291868bf81428472e5f750676e1108f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7164022bfe91ad2fffd538b2aa9e424a362b4d4f8b9e7f452ac056ae7caa0f80"
    sha256 cellar: :any_skip_relocation, ventura:       "7164022bfe91ad2fffd538b2aa9e424a362b4d4f8b9e7f452ac056ae7caa0f80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e57fd8919d74380af3a18eb89802405aa772f8284aafe338f6d3faa378f2532"
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
