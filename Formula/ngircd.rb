class Ngircd < Formula
  desc "Lightweight Internet Relay Chat server"
  homepage "https://ngircd.barton.de/"
  url "https://ngircd.barton.de/pub/ngircd/ngircd-26.1.tar.xz"
  mirror "https://ngircd.sourceforge.io/pub/ngircd/ngircd-26.1.tar.xz"
  sha256 "55c16fd26009f6fc6a007df4efac87a02e122f680612cda1ce26e17a18d86254"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ngircd.barton.de/download.php"
    regex(/href=.*?ngircd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "acfbc81c0549606bdd4f9c450be16f471ce9651091cf68ecd2d1c8de0fcecaed"
    sha256 arm64_monterey: "2a099c7b6d8a01f6aba11859bf203e06907ccf8973d4b1acf766b82493627ce9"
    sha256 arm64_big_sur:  "76bbc7ff4b78c2582bee92e0493b083d36ab63ee8ad0bb6fe7fc86638dcb54e5"
    sha256 ventura:        "92313e1cdfc649c20fcccb57372f00872e0b34a2d847c002fbe6faf7a6021e8a"
    sha256 monterey:       "50d3ccd2a87132e386b54a987a53e2f652db6cf1055ba087ca81bb56fc97d37e"
    sha256 big_sur:        "8c87f44e004de24a0a1b2c38ec6cc8bcfc0261d80f2ebab0b337165b6c52126e"
    sha256 x86_64_linux:   "c3d318555f9f398f8e68909b949387a0737bc6d0c2e5730839ca0793e1261f50"
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
      prefix.install "contrib/MacOSX/de.barton.ngircd.plist.tmpl" => "de.barton.ngircd.plist"
      (prefix/"de.barton.ngircd.plist").chmod 0644

      inreplace prefix/"de.barton.ngircd.plist" do |s|
        s.gsub! ":SBINDIR:", sbin
        s.gsub! "/Library/Logs/ngIRCd.log", var/"Logs/ngIRCd.log"
      end
    end
  end

  test do
    # Exits non-zero, so test version and match Author's name supplied.
    assert_match "Alexander", pipe_output("#{sbin}/ngircd -V 2>&1")
  end
end
