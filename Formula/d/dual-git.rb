class DualGit < Formula
  desc "Shell script to manage multiple git account with different ssh key"
  homepage "https://github.com/HalilSacpapa/dual_git"
  url "https://github.com/HalilSacpapa/dual_git/archive/refs/tags/alpha-v0.1.1.tar.gz"
  version "0.1"
  sha256 "371b009384e504446bf4066167df96394ec6f5ab9feb579f294ea16d433d8620"
  license "BSD-2-Clause"

  depends_on "bash"

  def install
    libexec.install "dual_git.sh" => "dgit"
    libexec.install "setup_dual_ssh.sh"
    libexec.install "setup_clone_ssh.sh"
    libexec.install "manage_repo_origin.sh"

    (bin/"dgit").write_env_script libexec/"dgit", {
      PATH: "#{libexec}:$PATH",
    }

    chmod 0755, libexec/"dgit"
    chmod 0755, libexec/"setup_dual_ssh.sh"
    chmod 0755, libexec/"setup_clone_ssh.sh"
    chmod 0755, libexec/"manage_repo_origin.sh"
  end

  test do
    system "#{bin}/dgit", "--help"
  end
end
