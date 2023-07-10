class Pkcs11Provider < Formula
  desc "Openssl 3.x provider to access software or hardware tokens via PKCS#11 interface"
  homepage "https://github.com/latchset/pkcs11-provider"
  url "https://github.com/latchset/pkcs11-provider/releases/download/v0.2/pkcs11-provider-0.2.tar.xz"
  sha256 "c2650d4e5883fa5b13522fde820854e1921258aec6f11b9b10b46ed19d42053d"
  license "Apache-2.0"
  head "https://github.com/latchset/pkcs11-provider.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  def install
    args = %W[
      --prefix=#{prefix}
      --with-openssl=#{Formula["openssl@3"].opt_prefix}
    ]

    system "autoreconf", "-fiv"
    system "./configure", *args
    system "make", "install"
  end

  def caveats
    <<~EOS
      Please keep in mind, you will need to adjust the default openssl.cnf file, usually at:
        #{Formula["openssl@3"].pkgetc}/openssl.cnf
      Alternatively, you may set the provider via the environment variable as follows:
        export PKCS11_PROVIDER_MODULE="#{opt_lib}/ossl-modules/pkcs11.dylib"
      Check official guide for more details:
        https://github.com/latchset/pkcs11-provider/blob/main/HOWTO.md
    EOS
  end

  test do
    ENV["PKCS11_PROVIDER_MODULE"] = "#{opt_lib}/ossl-modules/pkcs11.dylib"
    ENV["OPENSSL_MODULES"] = "#{opt_lib}/ossl-modules"
    system "openssl", "list", "-provider", "pkcs11"
  end
end
