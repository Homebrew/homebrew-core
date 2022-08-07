# NOTE: Odd release numbers indicate unstable releases.
# Please only submit PRs for [x.even.x] version numbers:
# https://github.com/djcb/mu/commit/23f4a64bdcdee3f9956a39b9a5a4fd0c5c2370ba
class Mu < Formula
  desc "Tool for searching e-mail messages stored in the maildir-format"
  homepage "https://www.djcbsoftware.nl/code/mu/"
  url "https://github.com/djcb/mu/releases/download/v1.8.8/mu-1.8.8.tar.xz"
  sha256 "ac79eaa6cd2e01af7efe7d1f30a29a3e46f6d36abebc64f96d01c431cf38602e"
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
    sha256 arm64_monterey: "975f54e33a72351b6f7057076f810b9be94c4f9ee844036e6cf5c6d6b564a2cf"
    sha256 arm64_big_sur:  "3b7b1c9419df158ce507a9ac1a9350bb147ec14342f77b32ff30dbd865639a2a"
    sha256 monterey:       "f9523f30023b4fd09c8879890b7e6657bd893a32d29d3e9210cfe696ba68b944"
    sha256 big_sur:        "1334ad4bfa73d9c71ec880606b35fd14aef86621ad46f3450e0fcc666c8d39dd"
    sha256 catalina:       "3262a6fd56c0f0e690eab3613a901c8c8ee9cd1488b04d22bb30eacec12138c6"
    sha256 x86_64_linux:   "99c7cccc67f0462743b51f53941b8aa62502daadf3faf95fa8622909db7c41a0"
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
  depends_on "xapian"

  uses_from_macos "texinfo" => :build

  on_linux do
    depends_on "gcc"
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
