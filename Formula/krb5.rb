class Krb5 < Formula
  desc "Network authentication protocol"
  homepage "https://web.mit.edu/kerberos/"
  url "https://kerberos.org/dist/krb5/1.21/krb5-1.21.tar.gz"
  sha256 "69f8aaff85484832df67a4bbacd99b9259bd95aab8c651fbbe65cdc9620ea93b"
  license :cannot_represent
  revision 1

  livecheck do
    url :homepage
    regex(/Current release: .*?>krb5[._-]v?(\d+(?:\.\d+)+)</i)
  end

  bottle do
    sha256 arm64_ventura:  "e30a7486acd5cabf97978ff19f1b4e96eb22213660327acce2e74f8dd9d0c57d"
    sha256 arm64_monterey: "6b4885b818ff579345175438fbde3fc405c0fc7dd89a28faf444167634d4236c"
    sha256 arm64_big_sur:  "80b7d73ae2cf6efa84e4b3b0cbeed44b612e6553f3821c96474a03a71cb98b06"
    sha256 ventura:        "614ce16b48d832e29bb3bb4c3807f377ff8c8be88dbad5ce6b5f60a983767daa"
    sha256 monterey:       "0b96bced75f5cfe6ebc4a6da143189c945d09eea433506e6694c6430a7662fc7"
    sha256 big_sur:        "9f4d2185d1ab6a88483b3611bc1821d2448852127c6e4e5c6c168162c61373da"
    sha256 x86_64_linux:   "cb324a8c5a6c8f60143a4e24f235c0955183a7262c5a2fc6c08a3a9408645f99"
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
