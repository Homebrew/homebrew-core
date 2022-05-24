# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://www.mercurial-scm.org/release/mercurial-6.1.2.tar.gz"
  sha256 "a52810fc01409828c4974d0bc2cbb5c80e948d5b584cfb1a7699623e924a2f2a"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.mercurial-scm.org/release/"
    regex(/href=.*?mercurial[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "597e01ddd337bd9171a3276420ffd017825476667cf1ef85f2fb73a3afb2bbec"
    sha256 arm64_big_sur:  "c7c6f5d60074cc3b71bb27565aabd6a5ef946917dbd045fb97bcde28b32bd9dc"
    sha256 monterey:       "4f7f092a779a663332fdb2fefa695f83be6923b41036bb043a6af3963d4c35a8"
    sha256 big_sur:        "de0265d9d408a4f198ac4efc3ad2f0c7ab360b351c2f88235e1e5283340a9eeb"
    sha256 catalina:       "66f7adf15ad4de7b21b405696735d7cd7ff4f1cdaae0ad69294ea9061bd40253"
    sha256 x86_64_linux:   "0a522f21b1dd9cc483da171709fa70c98c9457920ec78a163eee01b688424773"
  end

  depends_on "python@3.10"

  def install
    ENV["HGPYTHON3"] = "1"

    # FIXME: python@3.10 formula's "prefix scheme" patch tries to install into
    # HOMEBREW_PREFIX/{lib,bin}, which fails due to sandbox. As workaround,
    # manually set the installation paths to behave like prior python versions.
    site_packages = prefix/Language::Python.site_packages("python3")
    inreplace "Makefile",
              "--prefix=\"$(PREFIX)\"",
              "\\0 --install-lib=\"#{site_packages}\" --install-scripts=\"#{prefix}/bin\""

    system "make", "PREFIX=#{prefix}",
                   "PYTHON=#{which("python3")}",
                   "install-bin"

    # Install chg (see https://www.mercurial-scm.org/wiki/CHg)
    cd "contrib/chg" do
      system "make", "PREFIX=#{prefix}",
                     "PYTHON=#{which("python3")}",
                     "HGPATH=#{bin}/hg", "HG=#{bin}/hg"
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
