class Nodenv < Formula
  desc "Manage multiple NodeJS versions"
  homepage "https://github.com/nodenv/nodenv"
  url "https://github.com/nodenv/nodenv/archive/v1.3.2.tar.gz"
  sha256 "db2b777c3e2de8c9b0f27aefd84bc9eb523b328b61ea910adb030185dea7a238"
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
