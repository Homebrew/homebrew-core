class Nodenv < Formula
  desc "Manage multiple NodeJS versions"
  homepage "https://github.com/nodenv/nodenv"
  url "https://github.com/nodenv/nodenv/archive/v1.1.2.tar.gz"
  sha256 "e8cfc0816f75b8c31dfd31089c442d7aafbffe26adb3078587c9ea2048df3519"
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

    if build.head?
      # Record exact git revision for `nodenv --version` output
      git_revision = `git rev-parse --short HEAD`.chomp
      inreplace "libexec/nodenv---version", /^(version=.+)/,
                                           "\\1--g#{git_revision}"
    end

    prefix.install "bin", "completions", "libexec"
  end

  test do
    shell_output("eval \"$(#{bin}/nodenv init -)\" && nodenv --version")
  end
end
