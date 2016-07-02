class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/jwilder/docker-gen"
  url "https://github.com/jwilder/docker-gen/releases/download/0.7.3/docker-gen-darwin-amd64-0.7.3.tar.gz"
  sha256 "bff27c3701facecd2488a830cb68f369b03143f1ef942f261cc879e64b36d790"

  bottle :unneeded

  def install
    bin.install "docker-gen"
  end

  test do
    system "#{bin}/docker-gen", "--version"
  end
end
