class DockerMachineNfs < Formula
  desc "Activates NFS on docker-machine"
  homepage "https://github.com/adlogix/docker-machine-nfs"
  url "https://github.com/adlogix/docker-machine-nfs/archive/0.5.2.tar.gz"
  sha256 "58ac0384a6db4edd648534af5d11ef3d39d13b4b534b9a7070912504ec3601f6"

  bottle :unneeded

  def install
    bin.install "docker-machine-nfs.sh" => "docker-machine-nfs"
  end

  test do
    system "#{bin}/docker-machine-nfs"
  end
end
