class Fwknop < Formula
  desc "Single Packet Authorization and Port Knocking"
  homepage "https://www.cipherdyne.org/fwknop/"
  url "https://www.cipherdyne.org/fwknop/download/fwknop-2.6.11.tar.gz"
  mirror "https://github.com/mrash/fwknop/releases/download/2.6.11/fwknop-2.6.11.tar.gz"
  sha256 "bcb4e0e2eb5fcece5083d506da8471f68e33fb6b17d9379c71427a95f9ca1ec8"
  license "GPL-2.0-or-later"
  head "https://github.com/mrash/fwknop.git", branch: "master"

  livecheck do
    url "https://www.cipherdyne.org/fwknop/download/"
    regex(/href=.*?fwknop[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "dd24ee01f0b52367ccb00111e7e3b28586cbe9b355b9461ac38175fcdaaa0b31"
    sha256 arm64_sonoma:   "3729d1321c0430837a4dfd26d0f504a4ef05d9798e37f12bf56149c0a88badc7"
    sha256 arm64_ventura:  "f30bdfd167ff41974f6df99b6305a3718fc6a032f742c71a45a8883060c09836"
    sha256 arm64_monterey: "ed89fd42fc0d208e93f3f2ea2d1441b0192cd5dbb23280029fd23bc4aa47200a"
    sha256 sonoma:         "b493935cf740cb8c95680dac3f7e5373a393d2f8127e96c7061b6e0142e1a7b6"
    sha256 ventura:        "7da542df5fadb3288b83899e0411c3fa2d19f55cce185c1721992b1d500f6bee"
    sha256 monterey:       "c8231997765dc550d2e0f61f6f6ba0bcbb85b3c4f985d10579ab058b2e8993d6"
    sha256 x86_64_linux:   "9e00519d9c3b6cb6c39eb4da55bbed6b0ba8767b7adf5e8f30fba8d3784070e6"
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
