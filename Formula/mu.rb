# Note that odd release numbers indicate unstable releases.
# Please only submit PRs for [x.x.even] version numbers:
# https://github.com/djcb/mu/commit/23f4a64bdcdee3f9956a39b9a5a4fd0c5c2370ba
class Mu < Formula
  desc "Tool for searching e-mail messages stored in the maildir-format"
  homepage "https://www.djcbsoftware.nl/code/mu/"
  url "https://github.com/djcb/mu/releases/download/1.2/mu-1.2.0.tar.xz"
  sha256 "f634c7f244dc6844ff71dc3c3e1893e48e193caa9e0e747eba616309775f053a"

  bottle do
    cellar :any
    sha256 "f8695cbe6df5fcd53c97c2df27924dc5152ac169bdfff6d4332c000d36d818ee" => :mojave
    sha256 "9f902b4b826662224f717e17cac441d622a31a813aa69ecb55fb4bd58dc9194d" => :high_sierra
    sha256 "2c5f3e427d6527a3be3b9268cbfda0fef31f91c0c7702bab75c790f44ed035a3" => :sierra
  end

  head do
    url "https://github.com/djcb/mu.git"

    depends_on "autoconf-archive" => :build
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "emacs" => :build
  depends_on "libgpg-error" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gmime"
  depends_on "xapian"

  def install
    system "autoreconf", "-ivf"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-lispdir=#{elisp}"
    system "make"
    system "make", "install"
  end

  def caveats; <<~EOS
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

    (testpath/"cur/1234567890.11111_1.host1!2,S").write <<~EOS
      From: "Road Runner" <fasterthanyou@example.com>
      To: "Wile E. Coyote" <wile@example.com>
      Date: Mon, 4 Aug 2008 11:40:49 +0200
      Message-id: <1111111111@example.com>

      Beep beep!
    EOS

    (testpath/"cur/0987654321.22222_2.host2!2,S").write <<~EOS
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
