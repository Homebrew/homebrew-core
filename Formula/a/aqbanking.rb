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
    sha256 arm64_tahoe:   "19192ff6c5a8ac4413f2f75f78b98d1014f0cfd548edfd5055e3a92690b88bf8"
    sha256 arm64_sequoia: "e53568cfc60410c68468acdfc0ad57c15f94377b2fb43d0c334a9816452e7fea"
    sha256 arm64_sonoma:  "b84fbbc035d6ac794d35d3d83e45491aaa908bc9fdf488376034ba3fea3e9a08"
    sha256 sonoma:        "ce6ca356971ac73b29a5e814e378d5d1cdcd223c5be2cbc74e78e6b4c995fd44"
    sha256 arm64_linux:   "d936623795fc53d502ac4028d767059eea1eaae97cf00a67c653fc73f30f804c"
    sha256 x86_64_linux:  "176286ab56ebc76fceffda0f57a8ab01990cc7dae19e3ad36b1a7ed675a422eb"
  end

  depends_on "gmp"
  depends_on "gwenhywfar"
  depends_on "ktoblzcheck"
  depends_on "libxml2"
  depends_on "libxmlsec1"
  depends_on "libxslt" # Our libxslt links with libgcrypt
  depends_on "openssl@3"
  depends_on "pkgconf" # aqbanking-config needs pkg-config for execution

  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
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
