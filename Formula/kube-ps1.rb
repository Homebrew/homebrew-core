class KubePs1 < Formula
  desc "Kubernetes prompt info for bash and zsh"
  homepage "https://github.com/jonmosco/kube-ps1"
  url "https://github.com/jonmosco/kube-ps1/archive/0.6.0.tar.gz"
  sha256 "c5536267051193aab92d39e74c4080eb3bfc7b362dd307446edb4c559e8f002a"
  head "https://github.com/jonmosco/kube-ps1.git"

  bottle :unneeded

  depends_on "kubernetes-cli"

  def install
    share.install "kube-ps1.sh"
  end

  def caveats; <<~EOS
    Make sure kube-ps1 is loaded from your ~/.zshrc and/or ~/.bashrc:
      source "#{opt_share}/kube-ps1.sh"
      PS1='$(kube_ps1)'$PS1
  EOS
  end

  test do
    kubeon = ". #{opt_share}/kube-ps1.sh && echo $KUBE_PS1_SHELL"
    assert_equal "zsh", shell_output("zsh -c '#{kubeon}'").chomp
  end
end
