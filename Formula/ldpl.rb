class Ldpl < Formula
  desc "Compiled programming language inspired by COBOL"
  homepage "https://www.ldpl-lang.org/"
  url "https://github.com/Lartu/ldpl/archive/4.4.tar.gz"
  sha256 "c34fb7d67d45050c7198f83ec9bb0b7790f78df8c6d99506c37141ccd2ac9ff1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf32d6e3ea635273e2b9489962bbaf8e0cb635baf2f683ce140ca7b678e4b4dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c7715953497aa0104ad8262e84757529b33d1af90b9a41288895018515bea7f"
    sha256 cellar: :any_skip_relocation, monterey:       "cde038edd67c523982be570ffb9ad84615a66731fb7de753c58c5b33bda1691e"
    sha256 cellar: :any_skip_relocation, big_sur:        "528888090d44cc065bcd6fdb941bfa751dba25e66c086cf4b427cc1e86549783"
    sha256 cellar: :any_skip_relocation, catalina:       "7e5cd92ebf4f0babb34d7af78189e7915731fad5fac39e66d63ecbbce86a72d0"
    sha256 cellar: :any_skip_relocation, mojave:         "b9a0fdeb6134828ef4f60d81339185c5ac5a86123d6301035cbfb3b45c1a91ed"
    sha256 cellar: :any_skip_relocation, high_sierra:    "01f2a987ba4b74d1b50374c7a9a616703a2a8ad479aaad8b80ed8e936af91d80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efdc08bf31ea1c1540603ef30480dd816dd9d62f62f1d352b67936d1d7e005fc"
  end

  on_linux do
    # Disable running mandb as it needs to modify /var/cache/man
    # Copied from AUR: https://aur.archlinux.org/cgit/aur.git/tree/dont-do-mandb.patch?h=ldpl
    # Upstream ref: https://github.com/Lartu/ldpl/commit/66c1513a38fba8048c209c525335ce0e3a32dbe5
    # Remove in the next release.
    patch :DATA
  end

  def install
    cd "src" do
      system "make"
      system "make", "install", "PREFIX=#{prefix}"
    end
  end

  test do
    (testpath/"hello.ldpl").write <<~EOS
      PROCEDURE:
      display "Hello World!" crlf
    EOS
    system bin/"ldpl", "hello.ldpl", "-o=hello"
    assert_match "Hello World!", shell_output("./hello")
  end
end

__END__
diff --unified --recursive --text ldpl-4.4.orig/src/makefile ldpl-4.4/src/makefile
--- ldpl-4.4.orig/src/makefile	2019-12-16 13:09:46.441774536 -0300
+++ ldpl-4.4/src/makefile	2019-12-16 13:10:01.648441421 -0300
@@ -51,9 +51,6 @@
 	install -m 775 lpm $(DESTDIR)$(PREFIX)/bin/
 	install -d $(DESTDIR)$(PREFIX)/share/man/man1/
 	install ../man/ldpl.1 $(DESTDIR)$(PREFIX)/share/man/man1/
-ifneq ($(shell uname -s),Darwin)
-	mandb
-endif

 uninstall:
 	rm $(DESTDIR)$(PREFIX)/bin/ldpl
