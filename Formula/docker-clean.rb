class DockerClean < Formula
  desc "Script cleans Docker containers, images, networks, and volumes."
  homepage "https://github.com/ZZROTDesign/docker-clean"
  url "https://github.com/ZZROTDesign/docker-clean/archive/v2.0.3.tar.gz"
  sha256 "a2e1923fe2862ca2487e39000c68cba900711b768a8920dd1b1275a2fa0e6789"

  def install
    bin.install "docker-clean"
  end

  test do
    system "#{bin}/docker-clean", "--help"
  end
end
