# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://www.mercurial-scm.org/release/mercurial-5.7.tar.gz"
  sha256 "609c3e7c9276dd75b03b713eccc10f5e0553001f35ae21600bcea1509699c601"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.mercurial-scm.org/release/"
    regex(/href=.*?mercurial[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "73b164d1e12a6e2dad57b3b58199a24235d5e69fd30c34f0c7b6502180fdf24b"
    sha256 big_sur:       "5d9ba291e5eb80651356bbfee1bba223e3ed93aa5e078efe6702080098e0d221"
    sha256 catalina:      "3b773a555be1944f60bd49a45f03046cabe1202201a90d15bcf5eeb3868c6f8b"
    sha256 mojave:        "77750ea2d6e8b7bf9d294d859638b7d0b19e4ea659110d7646c67eb93c34cd4d"
  end

  depends_on "python@3.9"

  def install
    ENV["HGPYTHON3"] = "1"

    system "make", "PREFIX=#{prefix}", "PYTHON=python3", "install-bin"

    # Install chg (see https://www.mercurial-scm.org/wiki/CHg)
    cd "contrib/chg" do
      system "make", "PREFIX=#{prefix}", "PYTHON=python3", "HGPATH=#{bin}/hg",
                     "HG=#{bin}/hg"
      bin.install "chg"
    end

    # Configure a nicer default pager
    (buildpath/"hgrc").write <<~EOS
      [pager]
      pager = less -FRX
    EOS

    (etc/"mercurial").install "hgrc"

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

    <<~EOS
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
