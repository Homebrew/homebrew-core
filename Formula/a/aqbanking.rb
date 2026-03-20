class Aqbanking < Formula
  desc "Generic online banking interface"
  homepage "https://www.aquamaniac.de/rdm/projects/aqbanking"
  url "https://www.aquamaniac.de/rdm/attachments/download/652/aqbanking-6.9.1.tar.gz"
  sha256 "fc94a2bebfbb4fc26b98dc93c8fa36a8026298cd7995f79821c480db35587f6b"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.aquamaniac.de/rdm/projects/aqbanking/files"
    regex(/href=.*?aqbanking[._-](\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "4f05a3cddc798744d9174ad5ed28fb3f4bab78645d3cfa00a2420091aa3ff60b"
    sha256 arm64_sequoia: "956ae7ad273964a10b36851c6482237d8ca60d212fd542be5b8dfee70a235bbf"
    sha256 arm64_sonoma:  "2b97ebd2182dae86430f3e310dbcb54808b41b89352418afd7cabf3c9fc2c032"
    sha256 sonoma:        "b920e6ccecfec70bb2e63b3ab787c648e5ecda32948735710b97ff43a3ea453a"
    sha256 arm64_linux:   "787f1bdbca1850988b0e8c8541ede16e5ef95ab2bc03d885266fb82877df2c7c"
    sha256 x86_64_linux:  "5b045c02d114e190ca69c13d0c878ac43c4cf6b27e629af9e259ac8bc554643d"
  end

  depends_on "gmp"
  depends_on "gwenhywfar"
  depends_on "ktoblzcheck"
  depends_on "libxml2"
  depends_on "libxmlsec1"
  depends_on "libxslt" # Our libxslt links with libgcrypt
  depends_on "openssl@3"
  depends_on "pkgconf" # aqbanking-config needs pkg-config for execution

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV.deparallelize

    inreplace "aqbanking-config.in.in", "@PKG_CONFIG@", "pkg-config"
    system "./configure", "--enable-cli", *std_configure_args
    # This is banking software, so let's run the test suite.
    system "make", "check"
    system "make", "install"
  end

  test do
    ENV["TZ"] = "UTC"
    context = "balance.ctx"
    (testpath/context).write <<~EOS
      accountInfoList {
        accountInfo {
          char bankCode="110000000"
          char accountNumber="000123456789"
          char iban="US44110000000000123456789"
          char bic="BYLADEM1001"
          char currency="USD"

          balanceList {
            balance {
              char date="20221212"
              char value="-11096%2F100%3AUSD"
              char type="booked"
            } #balance
          } #balanceList
        } #accountInfo
      } #accountInfoList
    EOS

    match = "110000000 000123456789 12.12.2022 -110.96 US44110000000000123456789 BYLADEM1001"
    out = shell_output("#{bin}/aqbanking-cli -D .aqbanking listbal " \
                       "-T '$(bankcode) $(accountnumber) $(dateAsString) " \
                       "$(valueAsString) $(iban) $(bic)' < #{context}")
    assert_match match, out.gsub(/\s+/, " ")
  end
end
