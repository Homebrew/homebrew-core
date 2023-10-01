class Krb5 < Formula
  desc "Network authentication protocol"
  homepage "https://web.mit.edu/kerberos/"
  url "https://kerberos.org/dist/krb5/1.21/krb5-1.21.2.tar.gz"
  sha256 "9560941a9d843c0243a71b17a7ac6fe31c7cebb5bce3983db79e52ae7e850491"
  license :cannot_represent

  livecheck do
    url :homepage
    regex(/Current release: .*?>krb5[._-]v?(\d+(?:\.\d+)+)</i)
  end

  bottle do
    sha256 arm64_sonoma:   "2d4dc47f318eb4b612c6082831602dabf86737abaf16205efca110f79d2c4582"
    sha256 arm64_ventura:  "7d9d7b0073393cd9629f017b4dfe5866363884703fff78cbbff8a6cb39390f77"
    sha256 arm64_monterey: "23e6b429459601ee94ff71df2130d01e31498a2c2b6ffbc37223cb84fb71a06b"
    sha256 arm64_big_sur:  "b6dd4f6d440efce85e407f663b288586919fc99e442e94d0eb04f9371b34a65d"
    sha256 sonoma:         "20a39d385f0cdc34029de2e0c030fc0787940a7be69cdcaa9de6899170cbb731"
    sha256 ventura:        "3d61bf09ad35a994a36390723f15d2be2be9969a980884a45941300a8c9b33cf"
    sha256 monterey:       "aba14932d5689bc4f527838ff4750fcdce0c1f634d579e7e3b9fee4bd67d8c84"
    sha256 big_sur:        "4e3b7e7e810be949b2182a3e30a0a95a5c478fa70abb07de852a14a7664bc548"
    sha256 x86_64_linux:   "4bb56ec3b3263b64169a57e3722f54f60ee048a57d290dfffc0481e09d05ceb3"
  end

  keg_only :provided_by_macos

  depends_on "openssl@3"

  uses_from_macos "bison" => :build
  uses_from_macos "libedit"

  def install
    cd "src" do
      system "./configure", *std_configure_args,
                            "--disable-nls",
                            "--disable-silent-rules",
                            "--without-system-verto",
                            "--without-keyutils"
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/krb5-config", "--version"
    assert_match include.to_s,
      shell_output("#{bin}/krb5-config --cflags")
  end
end
