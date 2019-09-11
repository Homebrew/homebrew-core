class Nodenv < Formula
  desc "Manage multiple NodeJS versions"
  homepage "https://github.com/nodenv/nodenv"
  url "https://github.com/nodenv/nodenv/archive/v1.3.0.tar.gz"
  sha256 "8cbe96c13ca70655b8553a7e5d7a99aa5d0155822b5bef21475c33408bae9a4c"
  head "https://github.com/nodenv/nodenv.git"

  bottle :unneeded

  depends_on "node-build"

  def install
    inreplace "libexec/nodenv" do |s|
      s.gsub! "/usr/local", HOMEBREW_PREFIX
      s.gsub! '"${BASH_SOURCE%/*}"/../libexec', libexec
    end

    %w[--version hooks versions].each do |cmd|
      inreplace "libexec/nodenv-#{cmd}", "${BASH_SOURCE%/*}", libexec
    end

    # Compile bash extension
    system "src/configure"
    system "make", "-C", "src"

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
