class DockerMachineNfs < Formula
  desc "Activates NFS on docker-machine"
  homepage "https://github.com/adlogix/docker-machine-nfs"
  url "https://github.com/adlogix/docker-machine-nfs/archive/0.5.4.tar.gz"
  sha256 "ecb8d637524eaeb1851a0e12da797d4ffdaec7007aa28a0692f551e9223a71b7"
  license "MIT"

  bottle :unneeded

  def install
    bin.install "docker-machine-nfs.sh" => "docker-machine-nfs"
  end

  test do
    system "#{bin}/docker-machine-nfs"
  end
end
