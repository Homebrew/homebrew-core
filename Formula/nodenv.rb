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
    inreplace "libexec/nodenv" do |s|
      s.gsub! "/usr/local", HOMEBREW_PREFIX
      s.gsub! '"${BASH_SOURCE%/*}"/../libexec', libexec
    end

    %w[--version hooks versions].each do |cmd|
      inreplace "libexec/nodenv-#{cmd}", "${BASH_SOURCE%/*}", libexec
    end

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
