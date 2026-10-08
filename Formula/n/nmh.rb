class Nmh < Formula
  desc "New version of the MH mail handler"
  homepage "https://www.nongnu.org/nmh/"
  url "https://download.savannah.gnu.org/releases/nmh/nmh-1.8.tar.gz"
  mirror "https://download-mirror.savannah.gnu.org/releases/nmh/nmh-1.8.tar.gz"
  sha256 "366ce0ce3f9447302f5567009269c8bb3882d808f33eefac85ba367e875c8615"
  license "BSD-3-Clause"
  revision 2

  livecheck do
    url "https://download.savannah.gnu.org/releases/nmh/"
    regex(/href=.*?nmh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "3b5d9260ade160babccb2bdfa1d35504e7fb90abee69f95155ff176e5a663988"
    sha256 arm64_tahoe:       "1ea68fd3a7442d3a21e79a1dc9b22538a4da3160ddb9ea66daac1f366de1ebd4"
    sha256 arm64_sequoia:     "06ec8b1da1291cbc28b99fb6973651c69b8753adcd13e7336300f63a22747f7e"
    sha256 arm64_linux:       "db7defc901f7c041ebcdc75d133002a86bcc555ce0f813802a69e01d18d42a61"
    sha256 x86_64_linux:      "c7b4797ba8d0062fee6104d0c0cbc7f2d9c683718d71a916a4f08bec08f17ebb"
  end

  head do
    url "https://git.savannah.nongnu.org/git/nmh.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "openssl@4"
  depends_on "w3m"

  uses_from_macos "cyrus-sasl"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "gdbm"
    depends_on "readline"
  end

  conflicts_with "ali", because: "both install `ali` binaries"
  conflicts_with "cargo-dist", because: "both install `dist` binaries"
  conflicts_with "pick", because: "both install `pick` binaries"
  conflicts_with "repl", because: "both install `repl` binaries"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}", "--libdir=#{libexec}",
                          "--with-cyrus-sasl",
                          "--with-tls"
    system "make", "install"

    # Remove shim references
    inreplace prefix/"etc/nmh/mhn.defaults", Superenv.shims_path/"curl", "curl"
  end

  test do
    (testpath/".mh_profile").write "Path: Mail"
    (testpath/"Mail/inbox/1").write <<~EOS
      From: Mister Test <test@example.com>
      To: Mister Nobody <nobody@example.com>
      Date: Tue, 5 May 2015 12:00:00 -0000
      Subject: Hello!

      How are you?
    EOS
    ENV["TZ"] = "GMT"
    output = shell_output("#{bin}/scan -width 80")
    assert_equal("   1  05/05 Mister Test        Hello!<<How are you? >>\n", output)
  end
end
