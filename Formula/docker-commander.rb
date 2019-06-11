class DockerCommander < Formula
  desc "Execute commands in docker containers"
  homepage "https://github.com/daylioti/docker-commander"
  url "https://github.com/daylioti/docker-commander.git",
   :tag      => "1.1.4"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"
    src = buildpath/"src/github.com/daylioti/docker-commander"
    src.install buildpath.children
    src.cd do
      system "go", "build", "-ldflags", "-X main.version=#{version}"
      bin.install "docker-commander"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/docker-commander", "-v"
  end
end
