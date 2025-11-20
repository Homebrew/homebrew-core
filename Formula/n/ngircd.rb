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
    sha256 arm64_tahoe:    "1573a4080383c514d2f99460f1b06abc21d858e22cdd7965d12196746b0cdc07"
    sha256 arm64_sequoia:  "a5f1ec87f22aab290866fe3c59d3a3750354af29dd410c458b7dae0f3188b058"
    sha256 arm64_sonoma:   "b3230f61b1aece2cffd949a060abd8a8ff1d61a47f63b728839cda70a38cc685"
    sha256 arm64_ventura:  "2b428f0da716c05f7eaf374b55fb3afa078d216f2c115e995d6bfc8dc4806025"
    sha256 arm64_monterey: "a47033e2a117055247c69736d670faadbcd3db4c6531cf33ba72c769515874f2"
    sha256 sonoma:         "343f25208cdce2cfc06e9be0d7dacc6eefddaa0327cbcb99916ee78005f23c32"
    sha256 ventura:        "404aec8f8636c91f81fc63bcad319ae781948ef7d01b0b92747fc4d844d47dd4"
    sha256 monterey:       "8ef6f2e67ad12fe5bc9ce16c04ea822680f4480c357f612440d5307d94c7d3cd"
    sha256 arm64_linux:    "dc1aa95593ad0256ced4ac280d8076f9d5cf5522a6306e282032eb93aa31ef57"
    sha256 x86_64_linux:   "a060e572d41cbb75911a78eafb384d30aea9813c5ce1229b74f4941401c53e43"
  end

  depends_on "libident"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--sysconfdir=#{etc}",
                          "--enable-ipv6",
                          "--with-ident",
                          "--with-openssl"
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
