class DockerSwarm < Formula
  desc "Turn a pool of Docker hosts into a single, virtual host"
  homepage "https://github.com/docker/swarm"
  url "https://github.com/docker/swarm/archive/v1.2.8.tar.gz"
  sha256 "be8d368000e2afbe4cda87330805978bbb2d9e33cd15bc82a8669a8cd0bcd4c6"
  head "https://github.com/docker/swarm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f3940875a0cbb1cf562376e61ffb6206aa75e266931e54f52fe08c2ceaaf6329" => :high_sierra
    sha256 "17efa0a36074c19516377ed860540ed5e8672794607d8a1a78b7f18b12b0f403" => :sierra
    sha256 "de4c2cb59c9a198bec4bb6442cbb6fd0465964b27842d77d6d277429cfe51b27" => :el_capitan
    sha256 "01b32b2a21df9ffb5f3e0721cbb33f65aa5ef8e0207ec9648feb769fcb4ae932" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/docker/swarm").install buildpath.children
    cd "src/github.com/docker/swarm" do
      system "go", "build", "-o", bin/"docker-swarm"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docker-swarm --version")
  end
end
