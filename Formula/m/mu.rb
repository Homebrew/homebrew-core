# NOTE: Odd release numbers indicate unstable releases.
# Please only submit PRs for [x.even.x] version numbers:
# https://github.com/djcb/mu/commit/23f4a64bdcdee3f9956a39b9a5a4fd0c5c2370ba
class Mu < Formula
  desc "Tool for searching e-mail messages stored in the maildir-format"
  homepage "https://www.djcbsoftware.nl/code/mu/"
  url "https://github.com/djcb/mu/releases/download/v1.12.5/mu-1.12.5.tar.xz"
  sha256 "770b92e3072adae8777bd4e985c8b027c66ce0b7ef7cbb8eab4497b92ba68acb"
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
    sha256 cellar: :any, arm64_sonoma:   "26069fa881239b0cd682c0b9b37bfd15390123ca1c940c1dde4097b0c2d2e98f"
    sha256 cellar: :any, arm64_ventura:  "970817f29bc04c6987b87af39aafae5b9538e4a9cc6ef448fc28b3960d0fe07d"
    sha256 cellar: :any, arm64_monterey: "aa70c59b22a88c6934ba41329a26f23ef9c274d26e7cd0e73ea771d311d1ec63"
    sha256 cellar: :any, sonoma:         "7a172a029e74618d255f0876ffa24512f0eadff7c8a5b32cde0ac0d3157e6046"
    sha256 cellar: :any, ventura:        "f49773ebb6229e0a53d38927356109af6078ec852b9cd3fc7361302c8343bcd7"
    sha256 cellar: :any, monterey:       "3ba357409dc6d0d14831938cba9f404e8cf61b4aa1ac92df0cb89c76fbb33aab"
    sha256               x86_64_linux:   "42d54ef3f7fb26a9acda8a97b9c488aa22b8e70c13f198312f12190ba7c9613c"
  end

  depends_on "emacs" => :build
  depends_on "libgpg-error" => :build
  depends_on "libtool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gmime"
  depends_on "xapian"

  conflicts_with "mu-repo", because: "both install `mu` binaries"

  fails_with gcc: "5"

  def install
    system "meson", "setup", "build", "-Dlispdir=#{elisp}", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
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
