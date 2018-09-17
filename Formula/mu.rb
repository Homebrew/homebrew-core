# Note that odd release numbers indicate unstable releases.
# Please only submit PRs for [x.x.even] version numbers:
# https://github.com/djcb/mu/commit/23f4a64bdcdee3f9956a39b9a5a4fd0c5c2370ba
class Mu < Formula
  desc "Tool for searching e-mail messages stored in the maildir-format"
  homepage "https://www.djcbsoftware.nl/code/mu/"
  url "https://github.com/djcb/mu/releases/download/v1.0/mu-1.0.tar.xz"
  sha256 "966adc4db108f8ddf162891f9c3c24ba27f78c31f86575a0e05fbf14e857a513"

  bottle do
    sha256 "c17d20c6deebf4f75da2f7fa028114f48176714c46d1f204d469880121e9b6d0" => :mojave
    sha256 "d6d58dc0b9fc5d5454c0bf68230f6f8fb8cb973821de3e41ec267ce2614d8ec3" => :high_sierra
    sha256 "0a818cbcfa365710bd48a97092218042dc8d00afd73b3f781c0982f8668a8410" => :sierra
    sha256 "588ebfb6e7d577e8efd4a38ca1ae598998c8e015dd1101db8785641bdea17f6a" => :el_capitan
  end

  head do
    url "https://github.com/djcb/mu.git"

    depends_on "autoconf-archive" => :build
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libgpg-error" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "xapian"
  depends_on "emacs" => :optional

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
