# Note that odd release numbers indicate unstable releases.
# Please only submit PRs for [x.x.even] version numbers:
# https://github.com/djcb/mu/commit/23f4a64bdcdee3f9956a39b9a5a4fd0c5c2370ba
class Mu < Formula
  desc "Tool for searching e-mail messages stored in the maildir-format"
  homepage "https://www.djcbsoftware.nl/code/mu/"
  url "https://github.com/djcb/mu/releases/download/0.9.18/mu-0.9.18.tar.gz"
  sha256 "6559ec888d53f8e03b87b67148a73f52fe086477cb10e43f3fc13ed7f717e809"
  revision 1

  bottle do
    sha256 "7a22948357dea29fea7aad7fb40a1d40c91587a9ae6d5584fdc926c051558394" => :sierra
    sha256 "2668d780329437c1a9aa3a59a545f227adb2effcd162c61a57d162c0dea27596" => :el_capitan
    sha256 "5021092fa9584e6ed4755a61d675dbd89108706de2b4f4e35fe0597a5a79fcb1" => :yosemite
  end

  head do
    url "https://github.com/djcb/mu.git"

    depends_on "autoconf-archive" => :build
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libgpg-error" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "xapian"
  depends_on :emacs => ["23", :optional]

  # Currently requires gmime 2.6.x
  resource "gmime" do
    url "https://download.gnome.org/sources/gmime/2.6/gmime-2.6.23.tar.xz"
    sha256 "7149686a71ca42a1390869b6074815106b061aaeaaa8f2ef8c12c191d9a79f6a"
  end

  def install
    resource("gmime").stage do
      system "./configure", "--prefix=#{prefix}/gmime", "--disable-introspection"
      system "make", "install"
      ENV.append_path "PKG_CONFIG_PATH", "#{prefix}/gmime/lib/pkgconfig"
    end

    # Explicitly tell the build not to include emacs support as the version
    # shipped by default with macOS is too old.
    ENV["EMACS"] = "no" if build.without? "emacs"

    system "autoreconf", "-ivf"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-lispdir=#{elisp}"
    system "make"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    Existing mu users are recommended to run the following after upgrading:

      mu index --rebuild
    EOS
  end

  # Regression test for:
  # https://github.com/djcb/mu/issues/397
  # https://github.com/djcb/mu/issues/380
  # https://github.com/djcb/mu/issues/332
  test do
    mkdir (testpath/"cur")

    (testpath/"cur/1234567890.11111_1.host1!2,S").write <<-EOS.undent
      From: "Road Runner" <fasterthanyou@example.com>
      To: "Wile E. Coyote" <wile@example.com>
      Date: Mon, 4 Aug 2008 11:40:49 +0200
      Message-id: <1111111111@example.com>

      Beep beep!
    EOS

    (testpath/"cur/0987654321.22222_2.host2!2,S").write <<-EOS.undent
      From: "Wile E. Coyote" <wile@example.com>
      To: "Road Runner" <fasterthanyou@example.com>
      Date: Mon, 4 Aug 2008 12:40:49 +0200
      Message-id: <2222222222@example.com>
      References: <1111111111@example.com>

      This used to happen outdoors. It was more fun then.
    EOS

    system "#{bin}/mu", "index",
                        "--muhome",
                        testpath,
                        "--maildir=#{testpath}"

    mu_find = "#{bin}/mu find --muhome #{testpath} "
    find_message = "#{mu_find} msgid:2222222222@example.com"
    find_message_and_related = "#{mu_find} --include-related msgid:2222222222@example.com"

    assert_equal 1, shell_output(find_message).lines.count
    assert_equal 2, shell_output(find_message_and_related).lines.count,
                 "You tripped over https://github.com/djcb/mu/issues/380\n\t--related doesn't work. Everything else should"
  end
end
