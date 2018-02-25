class KubePs1 < Formula
  desc "Kubernetes prompt info for bash and zsh"
  homepage "https://github.com/jonmosco/kube-ps1"
  url "https://github.com/jonmosco/kube-ps1/archive/0.5.0.tar.gz"
  sha256 "ac0ecfb5f943a40d36743aba4179efe4af0b9b204c99fb6d31c4239f356e34dd"
  head "https://github.com/jonmosco/kube-ps1.git"

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
