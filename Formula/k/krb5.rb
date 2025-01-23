class Krb5 < Formula
  desc "Network authentication protocol"
  homepage "https://web.mit.edu/kerberos/"
  url "https://kerberos.org/dist/krb5/1.21/krb5-1.21.3.tar.gz"
  sha256 "b7a4cd5ead67fb08b980b21abd150ff7217e85ea320c9ed0c6dadd304840ad35"
  license :cannot_represent

  livecheck do
    url :homepage
    regex(/Current release: .*?>krb5[._-]v?(\d+(?:\.\d+)+)</i)
  end

  bottle do
    sha256 arm64_sequoia:  "75d0ce70b754c159e642f7e9afff27add08203423792f34c240a20ea014bfcec"
    sha256 arm64_sonoma:   "c7e8ec4458b77cb3bdc1bea7b6db6f6dfa6bb6c377cc0e6bd48f6d3f89d98f6b"
    sha256 arm64_ventura:  "e13b0f482b86a0139a13b482c4203540d1da19e82f29abd11ce155179a847c78"
    sha256 arm64_monterey: "b776903543fdcbf9af790c1ee6a6197b51bd00ad4f67c1f03e1741a352b0a756"
    sha256 sonoma:         "2ceff13b1041a0c1fe479069725c95cc0297cb221a616b4e4be107a745660d46"
    sha256 ventura:        "af7bd61f35af7725018817b4625b664f61efd4370d3fa6e0171bb49b968ab0b9"
    sha256 monterey:       "625e89432d8dc4a6571ae3db24cdd793f0bd058cff43c09eb565b41c7012ca9e"
    sha256 x86_64_linux:   "f5b4cafedb315e92a31a0a5d87e33f7826952bcc5c093ba65817c61247799601"
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
    system bin/"krb5-config", "--version"
    assert_match include.to_s,
      shell_output("#{bin}/krb5-config --cflags")
  end
end
