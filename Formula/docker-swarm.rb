class DockerSwarm < Formula
  desc "Turn a pool of Docker hosts into a single, virtual host"
  homepage "https://github.com/docker/classicswarm"
  url "https://github.com/docker/classicswarm/archive/v1.2.9.tar.gz"
  sha256 "13d0d39dbd2bccb32016e6aa782da67b6207f203e253e06b0f6eb4f25da85474"
  license "Apache-2.0"
  head "https://github.com/docker/classicswarm.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e5d1386efa30e9116f4f4d18be99f48d0953f45ae1b1e0c2634f7592b8e125d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "63847c7c545c26275220e214dbf7af426ddd5ac11aaeabd9586b70d22768d764"
    sha256 cellar: :any_skip_relocation, monterey:       "16b940f3f84c2edb617fd758284cf953c0903c0eb713b631922de2e0efcb4fc1"
    sha256 cellar: :any_skip_relocation, catalina:       "e2d8d18ea613fd94a32e0918f29238836b89dd32464e8f6e1145e744348ab0cd"
    sha256 cellar: :any_skip_relocation, mojave:         "d3cc672187adb5d73dfb2b6a90326de6ad228ccf48141ef3242447ca0416aee3"
    sha256 cellar: :any_skip_relocation, high_sierra:    "29e47d799c8e2d2977dd58444095a51c9ac7f261f56eeb5d5b6f71ed299e7533"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "352ec826e8b8f007c10cc3db1a5a10fd85a7994936b5e2abc190e64912bcc51c"
  end

  # "Classic Swarm has been archived and is no longer actively developed. You
  # may want to use the Swarm mode built into the Docker Engine instead, or
  # another orchestration system."
  disable! date: "2022-07-31", because: :repo_archived

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
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
