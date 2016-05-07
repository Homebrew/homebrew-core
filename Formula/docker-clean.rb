# Docker-Clean Script
# Maintained by Killian Brackey && Sean Kilgarriff at ZZROT Design
# Contact us at docker@zzrot.com for any issues or fork and pull from
# the Github repo below.  Happy cleaning!

class DockerClean < Formula
  desc "Script cleans Docker containers, images, networks, and volumes."
  homepage "https://github.com/ZZROTDesign/docker-clean"
  url "https://github.com/ZZROTDesign/docker-clean/archive/v2.0.1.tar.gz"
  sha256 "35aca23eb75043924b14b058acdc15714e19b6395ae2a32ce4ec90b88f70b6d0"

  def install
    bin.install "docker-clean"
  end

  test do
    system "#{bin}/docker-clean", "--help"
  end
end
