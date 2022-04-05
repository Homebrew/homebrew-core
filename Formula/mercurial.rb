# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://www.mercurial-scm.org/release/mercurial-6.1.1.tar.gz"
  sha256 "57b8a461d0ce13d9ae3817d8a8bdf9032e34edfaac3dbccb3b66b835dce93388"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.mercurial-scm.org/release/"
    regex(/href=.*?mercurial[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "d6b5e6bc660cbc01ecdfed0b90df3d4ce3195c65b29027e047b516ac3f799630"
    sha256 arm64_big_sur:  "ef7f7f8c265598f62831076d14ea16c8c4959a03df454ed411e104905d8c237d"
    sha256 monterey:       "c463e4f24ed16f6f6d1d8bb8616dbf926d1596baae77628e3b2d997836c2c610"
    sha256 big_sur:        "7a42f70b5488f133cad374ca42c356416ef9c2058874f69462072feec454f604"
    sha256 catalina:       "b9263c142b8e25367f6d7c4c6f09335597b8db5a42ed372523405a1cfcfb26c3"
    sha256 x86_64_linux:   "5231a53de47f3ca54fdef9fff470a11f6d7bf725cbfaa2b99b28f32ff144a36c"
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
