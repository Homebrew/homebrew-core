class KubePs1 < Formula
  desc "Kubernetes prompt info for bash and zsh"
  homepage "https://github.com/jonmosco/kube-ps1"
  url "https://github.com/jonmosco/kube-ps1/archive/v0.8.0.tar.gz"
  sha256 "7e57dc42d60f6c18fc1c814800c74b0ffb4e6f9d8e2b53f6f40bd7076f6c50a0"
  license "Apache-2.0"
  head "https://github.com/jonmosco/kube-ps1.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e5d9cf3512efbda9b7fcbabd2726adbee97ae8c38596835197f648b14b7d94ab"
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
