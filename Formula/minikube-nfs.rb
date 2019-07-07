class MinikubeNfs < Formula
  desc "Activates NFS on minikube"
  homepage "https://github.com/kunalparmar/minikube-nfs"
  url "https://github.com/kunalparmar/minikube-nfs/archive/v0.1.tar.gz"
  sha256 "6022a3adbbea1ef0351808ff06d8570436fdd9adb28fff1dae8dde3cbe758a3d"

  bottle :unneeded

  def install
    bin.install "minikube-nfs.sh" => "minikube-nfs"
  end

  test do
    system "#{bin}/minikube-nfs", "-h"
  end
end
