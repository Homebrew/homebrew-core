require "language/go"

class DockerSwarm < Formula
  desc "Turn a pool of Docker hosts into a single, virtual host"
  homepage "https://github.com/docker/swarm"
  url "https://github.com/docker/swarm/archive/v1.2.0.tar.gz"
  sha256 "8a30745ef4129a848dd2e88fc511c9eb85af07fbdbb46645f2e860b2aacdf8e6"
  head "https://github.com/docker/swarm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1d728f7955fe753e0934d57c26b25a083d6ea1ab6869bfb0e7930ebfd06df97a" => :el_capitan
    sha256 "a3cdbbd02e97e8e132bc2ccbb726254d75779160fde64021d15077320aa12441" => :yosemite
    sha256 "5c52c0fcbc56a0fb498f20a6e9c461e0ae0d8b6fe3b8f1519a3a44890c00abe5" => :mavericks
  end

  depends_on "go" => :build

  def install
    mkdir_p buildpath/"src/github.com/docker"
    ln_s buildpath, buildpath/"src/github.com/docker/swarm"
    ENV["GOPATH"] = "#{buildpath}/Godeps/_workspace:#{buildpath}"
    system "go", "build", "-o", "docker-swarm"
    bin.install "docker-swarm"
  end

  test do
    output = shell_output(bin/"docker-swarm --version")
    assert_match "swarm version #{version} (HEAD)", output
  end
end
