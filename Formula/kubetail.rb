class Kubetail < Formula
  desc "Bash script to tail Kubernetes logs from multiple pods at the same time"
  homepage "https://github.com/johanhaleby/kubetail"
  url "https://github.com/johanhaleby/kubetail/archive/1.6.13.tar.gz"
  sha256 "a4aeea1cffede44d5e8b030b6ead3ffe25fd3c1e7c5b7c82905df65cceac1254"
  license "Apache-2.0"
  head "https://github.com/johanhaleby/kubetail.git", branch: "master"

  depends_on "kubernetes-cli" => :test

  uses_from_macos "bash"

  def install
    bin.install "kubetail"

    bash_completion.install "completion/kubetail.bash" => "kubetail"
    zsh_completion.install "completion/kubetail.zsh" => "_kubetail"
    fish_completion.install "completion/kubetail.fish"
  end

  test do
    assert_match "server localhost:8080 was refused",
      shell_output("#{bin}/kubetail brew-pod-v1 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/kubetail --version")
  end
end
