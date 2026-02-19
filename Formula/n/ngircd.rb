class Ngircd < Formula
  desc "Lightweight Internet Relay Chat server"
  homepage "https://ngircd.barton.de/"
  url "https://ngircd.barton.de/pub/ngircd/ngircd-27.tar.xz"
  mirror "https://ngircd.sourceforge.io/pub/ngircd/ngircd-27.tar.xz"
  sha256 "6897880319dd5e2e73c1c9019613509f88eb5b8daa5821a36fbca3d785c247b8"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ngircd.barton.de/download.php"
    regex(/href=.*?ngircd[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "5427f5fc9fd0c74ef8f81724a119409ea2dae4d6f69c645ed3320eb5172631f1"
    sha256 arm64_sequoia: "275f0535d103dcf449280ca69691707072a6f2679056aa3a1a46a98688d735ad"
    sha256 arm64_sonoma:  "f2d08b20a4d7d93166f5ab9e47835f16901ed30e885e2b3d70c54306668bc80b"
    sha256 sonoma:        "c9e2d378750febc17b6e379d8bda929925c19aefa676d491b5aeb0fbcefe0a49"
    sha256 arm64_linux:   "02fa316807955b6296b0a9b6eade6a813a62b6f327e9afddc89e306b9130d295"
    sha256 x86_64_linux:  "bf948fd7fa99293c8df2802456e83da3f0c85c5e709308b7af323663b96726f5"
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
