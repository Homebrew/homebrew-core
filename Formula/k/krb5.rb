class Krb5 < Formula
  desc "Network authentication protocol"
  homepage "https://web.mit.edu/kerberos/"
  url "https://kerberos.org/dist/krb5/1.21/krb5-1.21.1.tar.gz"
  sha256 "7881c3aaaa1b329bd27dbc6bf2bf1c85c5d0b6c7358aff2b35d513ec2d50fa1f"
  license :cannot_represent

  livecheck do
    url :homepage
    regex(/Current release: .*?>krb5[._-]v?(\d+(?:\.\d+)+)</i)
  end

  bottle do
    sha256 arm64_ventura:  "fa17fb49aa0363f2de649bd8b6ca370d3a97dee5e7299bc07e6b7b344d4ccc59"
    sha256 arm64_monterey: "5760aac9f37d8500d50bb598a30f359c634a50fac8938dfae30dde196eea7b78"
    sha256 arm64_big_sur:  "4451b71c7ba7ee3ba0672902e5f144868a44b9e2b94254cc0d283c092f3a0940"
    sha256 ventura:        "96ea0626a36b769ed4bc56a8c2e4eca44892426edcfa7661964bd29d57b80d14"
    sha256 monterey:       "cb3da2bf3c62782d5795c89f30cc5fccf675307df276ac17f0d0c6ae8a62845b"
    sha256 big_sur:        "f133bd49a4feb6dabddc22667bdcf8663c7a1be2ff5e5f4feee8de63a1c32244"
    sha256 x86_64_linux:   "eb9b6638eeac1834e233fffef4e1ac145c5d38ae2f00c7844fe06afad26195ba"
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
