class Kns < Formula
  desc "Kubernetes Namespace Switcher - switches k8s context and namespace by directory"
  homepage "https://github.com/nbu/kns"
  url "https://github.com/nbu/kns/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "5d8175900d4a26347ae1eff6347d24d935ac0b2f8e983fa7be428d6487e4f142"
  license "MIT"

  depends_on "bash"
  depends_on "kubernetes-cli"

  def install
    # Install main kns script
    bin.install "kns"

    # Install shell integration script to libexec
    libexec.install "kns.sh"
  end

  def caveats
    <<~EOS
      To enable automatic context switching, add to your ~/.bashrc or ~/.zshrc:
        source #{opt_libexec}/kns.sh

      Or run:
        echo 'source #{opt_libexec}/kns.sh' >> ~/.bashrc  # or ~/.zshrc

      Then reload your shell or run: source ~/.bashrc
    EOS
  end

  test do
    # Test that kns is installed and executable
    assert_match "kns - Kubernetes Namespace/Context Switcher", shell_output("#{bin}/kns help")
  end
end
