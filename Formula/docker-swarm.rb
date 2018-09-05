class DockerSwarm < Formula
  desc "Turn a pool of Docker hosts into a single, virtual host"
  homepage "https://github.com/docker/swarm"
  url "https://github.com/docker/swarm/archive/v1.2.9.tar.gz"
  sha256 "2f58872ddf3c92aa5e3dc4cc5302eb42aaf29c818d264986c6ade34ad7a1fa35"
  head "https://github.com/docker/swarm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "34aec7c65ed4eebcd8502162f285afc55bf8d26fd2c13dc92e0525db154f5198" => :mojave
    sha256 "5b642741143afb0af4da144bfe6ccf188c4310e25cc59a0e660e06da351e2096" => :high_sierra
    sha256 "6b0edf4b78d255048fee2fb89a0487e733b50ffb65f645e4604882b0ec446fa8" => :sierra
    sha256 "26d2efada3ba33ba6001f8bd900c18fbf005f9ac98d05f867db6235c9832c76c" => :el_capitan
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
