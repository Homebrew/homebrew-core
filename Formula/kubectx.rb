class Kubectx < Formula
  desc "Tool that can switch between kubectl contexts easily and create aliases"
  homepage "https://github.com/ahmetb/kubectx"
  url "https://github.com/ahmetb/kubectx/archive/v0.3.1.tar.gz"
  sha256 "4e995f5bec6f41c8d5b6e77f413a58ead077816348e72de26dde3655ec2b7d0b"
  head "https://github.com/ahmetb/kubectx.git"

  bottle :unneeded

  option "with-short-names", "link as \"kctx\" and \"kns\" instead"

  depends_on "kubernetes-cli" => :run

  def install
    bin.install "kubectx" => build.with?("short-names") ? "kctx" : "kubectx"
    bin.install "kubens" => build.with?("short-names") ? "kns" : "kubens"
    include.install "utils.bash"

    bash_completion.install "completion/kubectx.bash" => "kubectx"
    bash_completion.install "completion/kubens.bash" => "kubens"
    zsh_completion.install "completion/kubectx.zsh" => "_kubectx"
    zsh_completion.install "completion/kubens.zsh" => "_kubens"
  end

  test do
    assert_match "USAGE:", shell_output("#{bin}/kubectx -h 2>&1", 1)
    assert_match "USAGE:", shell_output("#{bin}/kubens -h 2>&1", 1)
  end
end
