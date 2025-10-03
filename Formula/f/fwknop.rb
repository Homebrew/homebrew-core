class Fwknop < Formula
  desc "Single Packet Authorization and Port Knocking"
  homepage "https://www.cipherdyne.org/fwknop/"
  url "https://www.cipherdyne.org/fwknop/download/fwknop-2.6.11.tar.gz"
  mirror "https://github.com/mrash/fwknop/releases/download/2.6.11/fwknop-2.6.11.tar.gz"
  sha256 "bcb4e0e2eb5fcece5083d506da8471f68e33fb6b17d9379c71427a95f9ca1ec8"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/mrash/fwknop.git", branch: "master"

  livecheck do
    url "https://www.cipherdyne.org/fwknop/download/"
    regex(/href=.*?fwknop[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "7963f9f9f757720644a3df1cfaeb3307b43dfc3148ece268a48fca4ca47bf83b"
    sha256 arm64_sequoia: "227c8c6bcd86942a72b26ab69e096cefd01941331e82ef5bf8c3942070081edf"
    sha256 arm64_sonoma:  "bc2f4972f2b2b07f2958590c47149d83ba0b82dc568d8da044b83c5b31312caa"
    sha256 arm64_ventura: "591c24145cf5caff0f7a02c20ef482bbd720df8f0224cbb3908a49f912edc0c8"
    sha256 sonoma:        "dadbd89d12097cafb572e66e31295745cb7420ff940fd985932946a23859fb6d"
    sha256 ventura:       "659d69cb42503ccb2d8fe7334985b3e20e50dcaa025c72005b7e08e548bc8994"
    sha256 arm64_linux:   "403b551d5a2cf7b34feae53ac83a788de7af8d7d32982262d1bba500529ac6cc"
    sha256 x86_64_linux:  "dc5ed49f5029429d1e0db9e575844e6517dd3339924d55c986df9a48485bfd95"
  end

  depends_on "gpgme"

  uses_from_macos "libpcap"

  on_macos do
    depends_on "libassuan"
    depends_on "libgpg-error"
  end

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  on_linux do
    depends_on "iptables"
  end

  def install
    args = %W[
      --disable-silent-rules
      --sysconfdir=#{etc}
      --with-gpgme
      --with-gpg=#{Formula["gnupg"].opt_bin}/gpg
    ]
    args << "--with-iptables=#{Formula["iptables"].opt_prefix}" unless OS.mac?
    system "./configure", *std_configure_args, *args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fwknop --version")
    assert_match(/KEY_BASE64:\s*.+/, shell_output("#{bin}/fwknop --key-gen"))
  end
end
