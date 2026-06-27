class Aqbanking < Formula
  desc "Generic online banking interface"
  homepage "https://www.aquamaniac.de/rdm/projects/aqbanking"
  url "https://www.aquamaniac.de/rdm/attachments/download/654/aqbanking-6.9.2.tar.gz"
  sha256 "244b5f7a139f829928f5cdc3f5f7488517b3e8aa63625a92741c3efc1892bb3f"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://www.aquamaniac.de/rdm/projects/aqbanking/files"
    regex(/href=.*?aqbanking[._-](\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_tahoe:   "eb9de815540e5b11939f8ce326d7e80e6538580572a5ed4d714ccf70e9f708ca"
    sha256 arm64_sequoia: "f56ac98bb9d7c7b54773b977e5acf2e05a7aea0c8daff5c47af9c63b08c2e2d9"
    sha256 arm64_sonoma:  "1557472822a13737517c1394eb396af62a4dde7db049bbaadbdaf928b2eec268"
    sha256 sonoma:        "82b8006ffc096f8e3308d29826a3df2e0ebe1c04e74a41e5c2141db8cc02923f"
    sha256 arm64_linux:   "20e1918caff75f3919d87f29eda585d2edcfce78b5fe475af13596d15c7e47c6"
    sha256 x86_64_linux:  "2f30c2d5c27d0bf261bc52fd7a820b6a72fb37dd97ca191b7f3d11200a6c0b9e"
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
