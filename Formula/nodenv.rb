class Nodenv < Formula
  desc "Manage multiple NodeJS versions"
  homepage "https://github.com/nodenv/nodenv"
  url "https://github.com/nodenv/nodenv/archive/v1.1.2.tar.gz"
  sha256 "e8cfc0816f75b8c31dfd31089c442d7aafbffe26adb3078587c9ea2048df3519"
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
