class Kubecm < Formula
  desc "Merge multiple kubeconfig"
  homepage "https://github.com/sunny0826/kubecm"
  version "0.10.2"
  license "Apache-2.0"
  bottle :unneeded

  if OS.mac?
    url "https://github.com/sunny0826/kubecm/releases/download/v0.10.2/kubecm_0.10.2_Darwin_x86_64.tar.gz"
    sha256 "01d67b3b6fdf349e30e75a43e40153e2b2e92f68c1301ad0483eba465a7ac582"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/sunny0826/kubecm/releases/download/v0.10.2/kubecm_0.10.2_Linux_x86_64.tar.gz"
    sha256 "4a0cf5b5cb47cdac57ae22528b3850a90cf8d9909b5560c243bd3a414be1438e"
  end
  
  depends_on "git"

  def install
    bin.install "kubecm"
    
    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/kubecm", "completion", "bash")
    (bash_completion/"kubecm").write output
    
    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/kubecm", "completion", "zsh")
    (zsh_completion/"_kubecm").write output
  end

  test do
    system "#{bin}/kubecm version"
  end
end
