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
    rebuild 1
    sha256 arm64_golden_gate: "2dad8f0e52214c496bbce97abd6cd1b7b64232b35089ff3278dd1b575ce4e732"
    sha256 arm64_tahoe:       "87bc6a006ee2a63d03860f388378b53405cd2bddcfaa702e960f7d7af502eb1e"
    sha256 arm64_sequoia:     "e8f213f92636952b0a7616a3022c32ec026af92c16c210b85b4131f5b722e158"
    sha256 arm64_linux:       "e5b1f3ac2780bfd8c7a553cd92c79c5abe730e01577a50c97fdc3c3230d143cc"
    sha256 x86_64_linux:      "d33cbb6f13b29f35c32fc26b9dafbfa9cc35b45d9c1f18c59e6f2f3c606a1365"
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
