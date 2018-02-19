class KubePs1 < Formula
  desc "Kubernetes prompt info for bash and zsh"
  homepage "https://github.com/jonmosco/kube-ps1"
  url "https://github.com/jonmosco/kube-ps1/archive/0.4.0.tar.gz"
  sha256 "0133c5b41609ab8b4e0715f6581a8ee006a979028ddd697bab7a28c02f903db5"
  head "https://github.com/jonmosco/kube-ps1"

  bottle :unneeded

  depends_on "kubernetes-cli" => :recommended

  def install
    share.install "kube-ps1.sh"
  end

  def caveats; <<~EOS
    Make sure kube-ps1 is loaded from your ~/.zshrc or ~/.bashrc:
      For zsh:
      source "#{opt_share}/kube-ps1.sh"
      PROMPT='$(kube_ps1) $PROMPT'

      For Bash:
      source "#{opt_share}/kube-ps1.sh"
      PS1="[\$(kube_ps1)]\$ "
    EOS
  end

  test do
    kubeon = ". #{opt_share}/kube-ps1.sh && echo $KUBE_PS1_SHELL"
    assert_equal "zsh", shell_output("zsh -c '#{kubeon}'").chomp
  end
end
