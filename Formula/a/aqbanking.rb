class Aqbanking < Formula
  desc "Generic online banking interface"
  homepage "https://www.aquamaniac.de/rdm/projects/aqbanking"
  url "https://www.aquamaniac.de/rdm/attachments/download/654/aqbanking-6.9.2.tar.gz"
  sha256 "244b5f7a139f829928f5cdc3f5f7488517b3e8aa63625a92741c3efc1892bb3f"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url "https://www.aquamaniac.de/rdm/projects/aqbanking/files"
    regex(/href=.*?aqbanking[._-](\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_golden_gate: "e04bc57dcb71addae00e05648d20d149d250405d618b575382541420bad692e6"
    sha256 arm64_tahoe:       "696efe863b32507dfbc6598c8e54fed1caae549e76edebc08964a176122b3df3"
    sha256 arm64_sequoia:     "97ad082e12154aa94d3124e684ef8cfcb99cc512616fa6ea0504e05ba5e88cc5"
    sha256 arm64_linux:       "109a28db4849a75fff7668e0a8d4641d5d807d21b4c96c120afdac275dedd357"
    sha256 x86_64_linux:      "8f9ab05b78bab8b906615bcbae086e6ff3d9f7c740297719af73d31a4bca162c"
  end

  depends_on "gmp"
  depends_on "gwenhywfar"
  depends_on "libxml2"
  depends_on "libxmlsec1"
  depends_on "pkgconf" # aqbanking-config needs pkg-config for execution

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV.deparallelize
    ENV.append "LDFLAGS", "-Wl,-dead_strip_dylibs" if OS.mac? # avoid openssl linkage

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
