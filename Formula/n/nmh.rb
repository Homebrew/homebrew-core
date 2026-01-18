class Nmh < Formula
  desc "New version of the MH mail handler"
  homepage "https://www.nongnu.org/nmh/"
  url "https://download.savannah.gnu.org/releases/nmh/nmh-1.8.tar.gz"
  mirror "https://download-mirror.savannah.gnu.org/releases/nmh/nmh-1.8.tar.gz"
  sha256 "366ce0ce3f9447302f5567009269c8bb3882d808f33eefac85ba367e875c8615"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url "https://download.savannah.gnu.org/releases/nmh/"
    regex(/href=.*?nmh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "a5e47512714ba643f7419b066b01383a222d550272e0cd7e01274302f1b1f492"
    sha256 arm64_sequoia:  "60f74fdf361c84ce1aad906bb3e44be7d08c7553c8862646e2790eff719df9c3"
    sha256 arm64_sonoma:   "4b087eeaa03d67b95eab1e96ec6f87f683012adbbbc2d8693d1a99c2003d12a8"
    sha256 arm64_ventura:  "ca1326e5695a86d075a90e0b1e86916a748df6a376bd851f0d6d8432853660d5"
    sha256 arm64_monterey: "89888db63666acb8fc7e909a9e681194506cd51806d1b33c70ccb07802c93dcc"
    sha256 arm64_big_sur:  "61a5e6e21ff29746bef4ae4d89e86d7bf8f1d625a311c6d0203b8d4aa9eb12c1"
    sha256 sonoma:         "8c65bdbcf7a531a8a5e10793fe5ce6ae73941f2e589ce6bcda2a093835b8c3ed"
    sha256 ventura:        "3d599eb842fd242bc921500512f6dd79273dac4de44fd1e9b5b3e2178c974f99"
    sha256 monterey:       "1baa3243548fd2b34f59d1d5352602ee0a197ef0d91000de5d0aca382eb1cea8"
    sha256 big_sur:        "f2203024b91015dcc3c00fc690fbf253361ea12f443c97f7290985ea4e0f62c5"
    sha256 arm64_linux:    "4a390dfd9f429b5730138804bd89c2823531ae7f6aebb654637789f7917512d7"
    sha256 x86_64_linux:   "b53a0fb7791c968e762ac99a4ed0bc708ba6f0e3c39a7963cb3b29edb3b77845"
  end

  head do
    url "https://git.savannah.nongnu.org/git/nmh.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "openssl@3"
  depends_on "w3m"

  uses_from_macos "cyrus-sasl"

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
