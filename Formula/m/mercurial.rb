# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://www.mercurial-scm.org/release/mercurial-6.8.1.tar.gz"
  sha256 "030e8a7a6d590e4eaeb403ee25675615cd80d236f3ab8a0b56dcc84181158b05"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://www.mercurial-scm.org/release/"
    regex(/href=.*?mercurial[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "35a6ac7880d243ea479ce3050fd37393b4ff560c82dbb080f544a741c161b3d3"
    sha256 arm64_sonoma:  "13f62f94b954d1a028a289d9eef7e96dcddd1160014be79ffb9038e6542b451f"
    sha256 arm64_ventura: "f7d23fcee4b74c4d4919e1bb2c09d0706858fe32789a7923384fad9039e534ef"
    sha256 sonoma:        "a14b4e2f09bd8f4cddfa447314c396d802ed11f5d17763847960cbd55e60d114"
    sha256 ventura:       "763ee4b914fb66d6e207ec5be8ff82138babe77e60b2560cb820ab59c448e007"
    sha256 x86_64_linux:  "16fb921a2d7747be5ef79365143ccc1e04c2c955af228df39ed993161683dbed"
  end

  depends_on "python@3.13"

  # py3.13 build patch, upstream bug report, https://bz.mercurial-scm.org/show_bug.cgi?id=6926
  # proposed patch in https://lists.mercurial-scm.org/pipermail/mercurial-devel/2024-October/298120.html
  patch :DATA

  def install
    python3 = "python3.13"
    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."

    # Install chg (see https://www.mercurial-scm.org/wiki/CHg)
    system "make", "-C", "contrib/chg", "install", "PREFIX=#{prefix}", "HGPATH=#{bin}/hg", "HG=#{bin}/hg"

    # Configure a nicer default pager
    (buildpath/"hgrc").write <<~EOS
      [pager]
      pager = less -FRX
    EOS

    (etc/"mercurial").install "hgrc"

    # Install man pages, which come pre-built in source releases
    man1.install "doc/hg.1"
    man5.install "doc/hgignore.5", "doc/hgrc.5"

    # Move the bash completion script
    bash_completion.install share/"bash-completion/completions/hg"
  end

  def caveats
    return unless (opt_bin/"hg").exist?
    return unless deps.all? { |d| d.build? || d.test? || d.to_formula.any_version_installed? }

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
    touch "foobar"
    system bin/"hg", "init"
    system bin/"hg", "add", "foobar"
    system bin/"hg", "--config", "ui.username=brew", "commit", "-m", "initial commit"
    assert_equal "foobar\n", shell_output("#{bin}/hg locate")
    # Check for chg
    assert_match "initial commit", shell_output("#{bin}/chg log")
  end
end

__END__
diff --git a/hgdemandimport/__init__.py b/hgdemandimport/__init__.py
index 44a0a2d..a59c293 100644
--- a/hgdemandimport/__init__.py
+++ b/hgdemandimport/__init__.py
@@ -62,6 +62,7 @@ IGNORES = {
     '_weakrefset',
     'warnings',
     'threading',
+    'collections.abc',
 }

 _pypy = '__pypy__' in sys.builtin_module_names
