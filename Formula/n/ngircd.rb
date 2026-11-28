class Ngircd < Formula
  desc "Lightweight Internet Relay Chat server"
  homepage "https://ngircd.barton.de/"
  url "https://arthur.barton.de/pub/ngircd/ngircd-29.tar.xz"
  mirror "https://ngircd.sourceforge.io/pub/ngircd/ngircd-29.tar.xz"
  sha256 "4d681074619284c230842f865a2586e49e166a352de6e577feca692d21b2d5f5"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ngircd.barton.de/download.php"
    regex(/href=.*?ngircd[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    manifest_sha256 "4739a8bd910240246425127de82889e973bac9cc1bad8dfbf565990aaf8b87b4"
    sha256 arm64_golden_gate: "56f14ab9a074587f4d39529d62c31d0b2fbd2b256b2e4bda751def6cc9c8c087"
    sha256 arm64_tahoe:       "2df323d33b0203f8453a37401526db1e5e8dc3c17a6cc7bef50e3e5bf9535d3c"
    sha256 arm64_sequoia:     "4c8b43195e0a89611d251fe1c2dd0ab2f1df8059e4ba0a09f71a85101d8ceb4c"
    sha256 arm64_linux:       "65339d1c54a01fa8d145c04fb9a326d6809e1f7a8911fbf0ce0caeabc521b638"
    sha256 x86_64_linux:      "682b5e11e7a4a93f0878394ac9eb79494a18a42cb1975329931541f8de155513"
  end

  depends_on "libident"
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

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
