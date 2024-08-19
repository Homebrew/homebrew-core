class KubePs1 < Formula
  desc "Kubernetes prompt info for bash and zsh"
  homepage "https://github.com/jonmosco/kube-ps1"
  url "https://github.com/jonmosco/kube-ps1/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "f922c24eb4a6b41d1cd7839ac419a704694686c21472d9687da1592951d32681"
  license "Apache-2.0"
  head "https://github.com/jonmosco/kube-ps1.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8b7dbe43c977fc6410a1c076cdd9d488a42201b62be6389e0f09b63030bf5e1b"
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
