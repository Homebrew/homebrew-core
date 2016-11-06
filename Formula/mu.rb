# Note that odd release numbers indicate unstable releases.
# Please only submit PRs for [x.x.even] version numbers:
# https://github.com/djcb/mu/commit/23f4a64bdcdee3f9956a39b9a5a4fd0c5c2370ba
class Mu < Formula
  desc "Tool for searching e-mail messages stored in the maildir-format"
  homepage "https://www.djcbsoftware.nl/code/mu/"
  url "https://github.com/djcb/mu-releases/raw/master/mu-0.9.16.tar.gz"
  sha256 "55dff47f1ec2ea5a409a882009888c4f1b2b6ef2d81ee29753a649654752ee7e"
  head "https://github.com/djcb/mu.git"
  revision 1

  bottle do
    sha256 "e3635a6d29ca425c9c720a36fce436c535757b7c288d2b7edd9099630d9fbf9b" => :sierra
    sha256 "aaff2f3b1a501a7f12adb5e61014bc8ef6c7ca70c6b0908f502609110a55e931" => :el_capitan
    sha256 "971849ef3dee4bf59e2ec4b9fe141e2d786f65c41bfa17b474defbb705dbd011" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gmime"
  depends_on "xapian"
  depends_on :emacs => ["23", :optional]

  def install
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
