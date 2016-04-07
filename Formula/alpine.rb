class Alpine < Formula
  desc "News and email agent"
  homepage "http://patches.freeiz.com/alpine/"
  url "http://patches.freeiz.com/alpine/release/src/alpine-2.20.tar.xz"
  sha256 "ed639b6e5bb97e6b0645c85262ca6a784316195d461ce8d8411999bf80449227"

  bottle do
    sha256 "730553f37f597097bbba910de04dd5b9327d5b5a920c26f29406eca2d31f540d" => :el_capitan
    sha256 "cd774d63bf4327c4109a6b97fd7189f9618d53bd608bb314101f4880368f7662" => :yosemite
    sha256 "b35c3667a183c86dfa769e1d9e53669524930fda371422ab1c8519d3d807b8d5" => :mavericks
    sha256 "8f52d4ebe9e445ec975cabdd74c4a48cef80eebb21f18c33644e99de1a6d2173" => :mountain_lion
  end

  option "with-maildir", "Compile with support for Maildir format mailboxes"

  depends_on "openssl"

  patch do
    url "http://patches.freeiz.com/alpine/patches/alpine-2.20/maildir.patch.gz"
    sha256 "1ef0932b80d7f790ce6577a521a7b613b5ce277bb13cbaf0116bb5de1499caaa"
  end if build.with? "maildir"

  def install
    ENV.j1
    system "./configure", "--disable-debug",
                          "--with-ssl-dir=#{Formula["openssl"].opt_prefix}",
                          "--with-ssl-certs-dir=#{etc}/openssl",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/alpine", "-supported"
  end
end
