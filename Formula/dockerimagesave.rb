class Dockerimagesave < Formula
  desc "Download docker images by circumventing Docker cencorship in Cuba"
  homepage "https://github.com/jadolg/DockerImageSave"
  url "https://github.com/jadolg/DockerImageSave/archive/1.5.5.tar.gz"
  sha256 "d6ded048f60cb8a60a80642b725c1bbd5774b43c60cde775e6512a615b3aa6dc"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "dockerimagesave", "."
    bin.install "dockerimagesave"
  end

  test do
    system "go", "test", "-v"
  end
end
