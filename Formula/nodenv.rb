class Nodenv < Formula
  desc "Manage multiple NodeJS versions"
  homepage "https://github.com/nodenv/nodenv"
  url "https://github.com/nodenv/nodenv/archive/v1.0.0.tar.gz"
  sha256 "1b7d0a43f27d92d12af2658ac297b397b6b5b1e25af48e77de2e7e8675083586"
  head "https://github.com/nodenv/nodenv.git"

  bottle :unneeded

  depends_on "node-build" => :recommended

  def install
    inreplace "libexec/nodenv", "/usr/local", HOMEBREW_PREFIX
    prefix.install "bin", "libexec", "completions"
  end

  test do
    shell_output("eval \"$(#{bin}/nodenv init -)\" && nodenv --version")
  end
end
