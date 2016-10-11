class DockerLs < Formula
  desc "CLI tools for browsing and manipulating Docker registries"
  homepage "https://github.com/mayflower/docker-ls"
  url "https://github.com/mayflower/docker-ls.git",
      :tag => "v0.2.0",
      :revision => "45b56b14f05d2e2611a4d6bce7555e8ec04b0c2c"

  head "https://github.com/mayflower/docker-ls.git"

  depends_on "go" => :build

  def install
    ENV["AUTO_GOPATH"] = "1"

    system "make"

    bin.install "build/bin/docker-ls" => "docker-ls"
    bin.install "build/bin/docker-rm" => "docker-rm"
  end

  test do
    system "#{bin}/docker-ls", "version"
    system "#{bin}/docker-rm", "version"
  end
end
