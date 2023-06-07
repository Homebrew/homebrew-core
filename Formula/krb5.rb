class Krb5 < Formula
  desc "Network authentication protocol"
  homepage "https://web.mit.edu/kerberos/"
  url "https://kerberos.org/dist/krb5/1.21/krb5-1.21.tar.gz"
  sha256 "69f8aaff85484832df67a4bbacd99b9259bd95aab8c651fbbe65cdc9620ea93b"
  license :cannot_represent

  livecheck do
    url :homepage
    regex(/Current release: .*?>krb5[._-]v?(\d+(?:\.\d+)+)</i)
  end

  bottle do
    sha256 arm64_ventura:  "04d9621acc5c85d802c53f99fedc7ee97280a305aa928c03c5d18226a0c94aa7"
    sha256 arm64_monterey: "2ff7ea53c1536a9d27d12795886f39aa2a2c973a8ddf81124e944b1f3e622f0e"
    sha256 arm64_big_sur:  "5b1e3938c4adb7cfa0125f9921125231136f950a3ee987c9fb5403c8be6fa10f"
    sha256 ventura:        "dfc056001cd7d62d3278e27a6912a6925a9b3ff835e4e925a2ec76e5519e6f7f"
    sha256 monterey:       "2b7d8a77c5648deef7698f566df05fc37c4ad95426a9c2e5ae3e0b2a965791fd"
    sha256 big_sur:        "8ab26079cf70829a91d9d69d84c847c9a1480022c19dfb68b456e29d00ef2d2c"
    sha256 x86_64_linux:   "7013912b0901686da682ce541a0f57ef10039919add96e5a0106b9825b5d8fcf"
  end

  keg_only :provided_by_macos

  depends_on "openssl@1.1"

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
