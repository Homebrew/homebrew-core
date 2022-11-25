class KubePs1 < Formula
  desc "Kubernetes prompt info for bash and zsh"
  homepage "https://github.com/jonmosco/kube-ps1"
  url "https://github.com/jonmosco/kube-ps1/archive/v0.8.0.tar.gz"
  sha256 "7e57dc42d60f6c18fc1c814800c74b0ffb4e6f9d8e2b53f6f40bd7076f6c50a0"
  license "Apache-2.0"
  head "https://github.com/jonmosco/kube-ps1.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "686ec71211705bf86fd229811e89ee26f5714654d4b09de2eca68b36e8b987c3"
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
    assert_equal "bash", shell_output("bash -c '. #{opt_share}/kube-ps1.sh && echo $KUBE_PS1_SHELL'").chomp
    assert_match "zsh", shell_output("zsh -c '. #{opt_share}/kube-ps1.sh && echo $KUBE_PS1_SHELL'").chomp
  end
end
