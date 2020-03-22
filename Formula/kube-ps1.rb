class KubePs1 < Formula
  desc "Kubernetes prompt info for bash and zsh"
  homepage "https://github.com/jonmosco/kube-ps1"
  url "https://github.com/jonmosco/kube-ps1/archive/v0.7.0.tar.gz"
  sha256 "f5ccaf6537e944db5b9cf40d3f01cf99732dce5adaaaf840780aa38b1b030471"
  head "https://github.com/jonmosco/kube-ps1.git"

  bottle :unneeded

  depends_on "kubernetes-cli"

  def install
    share.install "kube-ps1.sh"
  end

  def caveats
    <<~EOS
      Make sure kube-ps1 is loaded from your ~/.zshrc and/or ~/.bashrc:
        source "#{opt_share}/kube-ps1.sh"
        PS1='$(kube_ps1)'$PS1
    EOS
  end

  test do
    ENV["LC_CTYPE"] = "en_CA.UTF-8"
    assert_equal "bash", shell_output("bash -c '. #{opt_share}/kube-ps1.sh && echo $KUBE_PS1_SHELL'").chomp
    assert_match "zsh", shell_output("zsh -c '. #{opt_share}/kube-ps1.sh && echo $KUBE_PS1_SHELL'").chomp
  end
end
