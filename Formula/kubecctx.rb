class Kubecctx < Formula
  desc "Script to manage multiple KUBECONF files"
  homepage "https://github.com/retr0h/kubecctx"
  url "https://github.com/retr0h/kubecctx/releases/download/0.1.0/v0.1.0.tar.gz"
  sha256 "91604e6b4ce63499b61ca79cd8f87550a22063cbaa5ea17f6aa7344d7aa02476"
  license "MIT"
  head "https://github.com/retr0h/kubecctx.git"

  bottle :unneeded

  def install
    share.install "kubecctx.sh"
  end

  def caveats
    <<~EOS
      Make sure kubecctx is loaded from your ~/.zshrc and/or ~/.bashrc:
        source "#{opt_share}/kubecctx.sh"
    EOS
  end

  test do
    ENV["LC_CTYPE"] = "en_CA.UTF-8"
    assert_equal "bash",
shell_output("bash -c '. #{opt_share}/kubecctx.sh && declare -F kubecctx &>/dev/null && echo bash'").chomp
    assert_match "zsh",
shell_output("zsh -c '. #{opt_share}/kubecctx.sh && declare -F kubecctx &>/dev/null && echo zsh'").chomp
  end
end
