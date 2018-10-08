class KubeFzf < Formula
  desc "Fuzzy search over Kubernetes Pods from the command-line"
  homepage "https://github.com/arunvelsriram/kube-fzf"
  url "https://github.com/arunvelsriram/kube-fzf/archive/v1.5.0.tar.gz"
  sha256 "c008cf9b288c0ce2ee3b6cf3693071c77a3e9cd8115e047d476da1b288370f57"
  depends_on "fzf" => :recommended

  def install
    bin.install "kube-fzf.sh"
    bin.install "describepod"
    bin.install "execpod"
    bin.install "findpod"
    bin.install "pfpod"
    bin.install "tailpod"
  end

  test do
    assert_match "USAGE:", shell_output("#{bin}/describepod -h", 1)
    assert_match "USAGE:", shell_output("#{bin}/execpod -h", 1)
    assert_match "USAGE:", shell_output("#{bin}/findpod -h", 1)
    assert_match "USAGE:", shell_output("#{bin}/pfpod -h", 1)
    assert_match "USAGE:", shell_output("#{bin}/tailpod -h", 1)
  end
end
