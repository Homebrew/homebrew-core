# NOTE: Odd release numbers indicate unstable releases.
# Please only submit PRs for [x.even.x] version numbers:
# https://github.com/djcb/mu/commit/23f4a64bdcdee3f9956a39b9a5a4fd0c5c2370ba
class Mu < Formula
  desc "Tool for searching e-mail messages stored in the maildir-format"
  homepage "https://www.djcbsoftware.nl/code/mu/"
  url "https://github.com/djcb/mu/releases/download/v1.10.3/mu-1.10.3.tar.xz"
  sha256 "c83970fcb6163c27d135c207d1a5eb6f38a5732161741a4a88da2ae894e0245f"
  license "GPL-3.0-or-later"
  head "https://github.com/djcb/mu.git", branch: "master"

  # We restrict matching to versions with an even-numbered minor version number,
  # as an odd-numbered minor version number indicates a development version:
  # https://github.com/djcb/mu/commit/23f4a64bdcdee3f9956a39b9a5a4fd0c5c2370ba
  livecheck do
    url :stable
    regex(/^v?(\d+\.\d*[02468](?:\.\d+)*)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "6f69efd71681388c34f9bba64f81c1b3bf388006d33a9b77f71134a56d38722a"
    sha256 arm64_monterey: "d5b275001181b75eb2ff19d32f3ad71a974ae569a5ecb220b76ea53967d0b450"
    sha256 arm64_big_sur:  "9be84eabdce2d62f954d937acec58e643913061aec80142be932dd549ed4d63a"
    sha256 ventura:        "ec84b9e7fabfffe1fa3cedb9afb6ed97d3551da588e1f940d9f5323ce3d74fd6"
    sha256 monterey:       "b160858b47c765777186ff00a164790a1f520d79bc7dc35b8a6238c969c09b9d"
    sha256 big_sur:        "935ae1231010fa00264b383ff96f419fd673acdff31705f6aaffcd27862fb213"
    sha256 x86_64_linux:   "3bf5395381e4ba091593e647d47c84968414999a439546945a337469e38220b8"
  end

  depends_on "emacs" => :build
  depends_on "libgpg-error" => :build
  depends_on "libtool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gmime"
  depends_on "guile" # Possible opportunistic linkage. TODO: Check if this can be removed.
  depends_on "xapian"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  conflicts_with "mu-repo", because: "both install `mu` binaries"

  fails_with gcc: "5"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Dlispdir=#{elisp}", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

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
      You tripped over djcb/mu#380
        --related doesn't work. Everything else should
    EOS
  end
end
