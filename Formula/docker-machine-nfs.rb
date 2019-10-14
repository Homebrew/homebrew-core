class DockerMachineNfs < Formula
  desc "Activates NFS on docker-machine"
  homepage "https://github.com/adlogix/docker-machine-nfs"
  url "https://github.com/adlogix/docker-machine-nfs/archive/0.5.3.tar.gz"
  sha256 "ad8fb4e9c3576ca5dd9f4014ff88a41e42c3c65c26c04a94122f79533050e0bb"

  bottle :unneeded

  def install
    bin.install "docker-machine-nfs.sh" => "docker-machine-nfs"
  end

  test do
    system "#{bin}/docker-machine-nfs"
  end
end
