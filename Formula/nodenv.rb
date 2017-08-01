class Nodenv < Formula
  desc "Manage multiple NodeJS versions"
  homepage "https://github.com/nodenv/nodenv"
  url "https://github.com/nodenv/nodenv/archive/v1.1.1.tar.gz"
  sha256 "12520d5a4d18dc9e809514176adab622c5f0e30a429b5671784b4f463ecd05a7"
  head "https://github.com/nodenv/nodenv.git"

  bottle :unneeded

  option "without-bash-extension", "Skip compilation of the dynamic bash extension to speed up nodenv."

  depends_on "node-build" => :recommended

  def install
    inreplace "libexec/nodenv", "/usr/local", HOMEBREW_PREFIX

    if build.with? "bash-extension"
      # Compile optional bash extension.
      system "src/configure"
      system "make", "-C", "src"
    end

    prefix.install "bin", "completions", "libexec"
  end

  test do
    shell_output("eval \"$(#{bin}/nodenv init -)\" && nodenv --version")
  end
end
