# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://mercurial-scm.org/release/mercurial-4.0.2.tar.gz"
  sha256 "ae6659dba27508a9a6417d535a89e282d5c8a5ea77b6e00af102822145b06d02"

  bottle do
    cellar :any_skip_relocation
    sha256 "a40959c29e9882dd3e803679dae9f634ff1eb8b4b4f4b4aa51593ce1654757c8" => :sierra
    sha256 "2b82ca30bcbe200fd1b34d82c8157cb3c3c966f9e3667118818179bbb86de5d6" => :el_capitan
    sha256 "caaa2987cfc8acf4dd7ce86167f5697700bbfb2f9ce15f125338958a862adbd9" => :yosemite
  end

  option "with-custom-python", "Install against the python in PATH instead of Homebrew's python"
  if build.with? "custom-python"
    depends_on :python
  else
    depends_on "python"
  end

  def install
    system "make", "PREFIX=#{prefix}", "install-bin"
    # Install man pages, which come pre-built in source releases
    man1.install "doc/hg.1"
    man5.install "doc/hgignore.5", "doc/hgrc.5"

    # install the completion scripts
    bash_completion.install "contrib/bash_completion" => "hg-completion.bash"
    zsh_completion.install "contrib/zsh_completion" => "_hg"
  end

  def caveats
    return unless (opt_bin/"hg").exist?
    cacerts_configured = `#{opt_bin}/hg config web.cacerts`.strip
    return if cacerts_configured.empty?
    <<-EOS.undent
      Homebrew has detected that Mercurial is configured to use a certificate
      bundle file as its trust store for TLS connections instead of using the
      default OpenSSL store. If you have trouble connecting to remote
      repositories, consider unsetting the `web.cacerts` property. You can
      determine where the property is being set by running:
        hg config --debug web.cacerts
    EOS
  end

  test do
    system "#{bin}/hg", "init"
  end
end
