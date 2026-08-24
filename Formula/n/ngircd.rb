class Ngircd < Formula
  desc "Lightweight Internet Relay Chat server"
  homepage "https://ngircd.barton.de/"
  url "https://arthur.barton.de/pub/ngircd/ngircd-28.tar.xz"
  mirror "https://ngircd.sourceforge.io/pub/ngircd/ngircd-28.tar.xz"
  sha256 "b48ba320a931d445ae335c47f88a9406a20f5c71c623bee5f7755d0522d435ee"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ngircd.barton.de/download.php"
    regex(/href=.*?ngircd[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "8420033aa662564ea50929687690e933b4ced45a802d6167e4e370092f93452c"
    sha256 arm64_sequoia: "8735f62952cfe1b1606dbabb8b2702a4d29eb7a11a148aef0262f9c9a1621108"
    sha256 arm64_sonoma:  "0b0cf7bc44eafface072719512c90d87ea21f416832e361258d0b90a1d195591"
    sha256 sonoma:        "e59912741a534222eea238627a9b747680fcd80c26b637c59aa73d1adfa4ebd6"
    sha256 arm64_linux:   "f7ab85c075855fe140f879f1335741153912efbbe622b2204b8c528dd8048244"
    sha256 x86_64_linux:  "8a3eef52801ab52e10cd3f1d858abe5b315ac9c2431afb12c2950968661b7fe1"
  end

  depends_on "libident"
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--disable-silent-rules",
                          "--sysconfdir=#{etc}",
                          "--enable-ipv6",
                          "--with-ident",
                          "--with-openssl",
                          *std_configure_args
    system "make", "install"

    if OS.mac?
      prefix.install "contrib/de.barton.ngircd.plist"
      (prefix/"de.barton.ngircd.plist").chmod 0644

      inreplace prefix/"de.barton.ngircd.plist" do |s|
        s.gsub! "/opt/ngircd/sbin", sbin
        s.gsub! "/Library/Logs/ngIRCd.log", var/"Logs/ngIRCd.log"
      end
    end
  end

  test do
    # Exits non-zero, so test version and match Author's name supplied.
    assert_match "Alexander", pipe_output("#{sbin}/ngircd -V 2>&1")
  end
end
