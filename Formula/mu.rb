# Note that odd release numbers indicate unstable releases.
# Please only submit PRs for [x.even.x] version numbers:
# https://github.com/djcb/mu/commit/23f4a64bdcdee3f9956a39b9a5a4fd0c5c2370ba
class Mu < Formula
  desc "Tool for searching e-mail messages stored in the maildir-format"
  homepage "https://www.djcbsoftware.nl/code/mu/"
  url "https://github.com/djcb/mu/archive/1.4.10.tar.gz"
  sha256 "a3fd3b56fb0872892427909888d55bae2c3f0d574494cb27853ae4907b2c8af9"
  license "GPL-3.0"

  bottle do
    cellar :any
    sha256 "ff8820080a32067627c8b8ea26a2a80e94d24833d33ffd5c130a251f36243dce" => :catalina
    sha256 "ae98cf1ff0fdbae8771d01a22078478cfb4b4248c3f664c135a7be6735194d4f" => :mojave
    sha256 "a9ef200573c8092384f30fcec9cd7b9ecf3e34b29a72fb17a72aadef86772c51" => :high_sierra
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

    system "#{bin}/mu", "init", "--muhome=#{testpath}", "--maildir=#{testpath}"
    system "#{bin}/mu", "index", "--muhome=#{testpath}"

    mu_find = "#{bin}/mu find --muhome=#{testpath} "
    find_message = "#{mu_find} msgid:2222222222@example.com"
    find_message_and_related = "#{mu_find} --include-related msgid:2222222222@example.com"

    assert_equal 1, shell_output(find_message).lines.count
    assert_equal 2, shell_output(find_message_and_related).lines.count, <<~EOS
      You tripped over https://github.com/djcb/mu/issues/380
        --related doesn't work. Everything else should
    EOS
  end
end
