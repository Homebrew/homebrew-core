class Krb5 < Formula
  desc "Network authentication protocol"
  homepage "https://web.mit.edu/kerberos/"
  url "https://kerberos.org/dist/krb5/1.22/krb5-1.22.1.tar.gz"
  sha256 "1a8832b8cad923ebbf1394f67e2efcf41e3a49f460285a66e35adec8fa0053af"
  license :cannot_represent

  livecheck do
    url :homepage
    regex(/Current release: .*?>krb5[._-]v?(\d+(?:\.\d+)+)</i)
  end

  bottle do
    sha256 arm64_tahoe:   "7922c7d39301812f11f49cc564c79b7e24822a6650216fb102e6209c837cef15"
    sha256 arm64_sequoia: "902884745603d3d55cdbe5e30ca2972a1d0829ae2512f6ef8e8731d92a607938"
    sha256 arm64_sonoma:  "5dc445bcf366abc34e62ae564695d123ce24ee9c0d625de7c62f4d0785a110ba"
    sha256 arm64_ventura: "ac9341e0db85afbf17f8d923d67527d5d6cac7c9dd0da09dbab36ffe5d9c2a02"
    sha256 sonoma:        "b6af4b9221012af0d3e7d364713d1ce95cc10e490973b66766fe3113409f0acd"
    sha256 ventura:       "3816d54634a8bee2ac51dda7c8cb5fd6dc3e9a25693c9242b9b80f4c9c262fd1"
    sha256 arm64_linux:   "5d657c89c3796d2acc33c0af7e707df90866fc8b83d20c0b80df7178005d2595"
    sha256 x86_64_linux:  "fe519bd1bd2742d34763055beac8767693c1a8a8c412259829f39b9d1a6c6a66"
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
