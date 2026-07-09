class KubePs1 < Formula
  desc "Kubernetes prompt info for bash and zsh"
  homepage "https://github.com/jonmosco/kube-ps1"
  url "https://github.com/jonmosco/kube-ps1/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "af44982ad27e492d3ade2d03223c944523070b0462839a9260df7483692c1bb0"
  license "Apache-2.0"
  head "https://github.com/jonmosco/kube-ps1.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d842ab5faead998444a3b9f26e315d4bcf350d2c20b87cb70b97061dca960b25"
  end

  depends_on "kubernetes-cli"

  uses_from_macos "zsh" => :test

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
    assert_equal "bash", shell_output("bash -c '. #{opt_share}/kube-ps1.sh && echo $(_kube_ps1_shell_type)'").chomp
    assert_match "zsh", shell_output("zsh -c '. #{opt_share}/kube-ps1.sh && echo $(_kube_ps1_shell_type)'").chomp
  end
end
