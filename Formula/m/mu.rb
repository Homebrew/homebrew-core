# NOTE: Odd release numbers indicate unstable releases.
# Please only submit PRs for [x.even.x] version numbers:
# https://github.com/djcb/mu/commit/23f4a64bdcdee3f9956a39b9a5a4fd0c5c2370ba
class Mu < Formula
  desc "Tool for searching e-mail messages stored in the maildir-format"
  homepage "https://www.djcbsoftware.nl/code/mu/"
  url "https://github.com/djcb/mu/releases/download/v1.14.4/mu-1.14.4.tar.xz"
  sha256 "3714ea0d1e4811bd2c160cc2e222dc00723485df9756e2d90f2bb66e90f894f7"
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
    sha256 arm64_golden_gate: "81457d8a83e505445fe5f6d253f376e31c70620027b3289331a9b88e4e12b7e8"
    sha256 arm64_tahoe:       "e01e887be6b15aacb1c693902926645e672a890d7876ed1236d1c8c76084e5d2"
    sha256 arm64_sequoia:     "8e2496099cf4e129b35e529e82fb8fd1100aa0d9cd3779b2fc53cd1ed99425d5"
    sha256 arm64_linux:       "dce42a315d16d1b41023fd88361ea68d45a125c67ba483733042ee5ff67c5092"
    sha256 x86_64_linux:      "8c5ddd60097a65134b7535c178f7c3ceb56ed7719d9b0e52e5d68e2152b7952e"
  end

  depends_on "cli11" => :build
  depends_on "cmake" => :build
  depends_on "emacs" => :build
  depends_on "libgpg-error" => :build
  depends_on "libtool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "texinfo" => :build
  depends_on "fmt"
  depends_on "glib"
  depends_on "gmime"
  depends_on "guile"
  depends_on "tl-expected"
  depends_on "xapian"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1600
    depends_on "gettext"
  end

  conflicts_with "mu-repo", because: "both install `mu` binaries"

  fails_with :clang do
    build 1600
    cause "needs std::views::join, missing from the macOS 14 SDK's libc++"
  end

  def install
    system "meson", "setup", "build", "-Dlispdir=#{elisp}", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    zsh_completion.install "mu/completion/mu-completion.zsh" => "_mu"
    bash_completion.install "mu/completion/mu-completion.bash" => "mu"
  end

  # Regression test for:
  # https://github.com/djcb/mu/issues/397
  # https://github.com/djcb/mu/issues/380
  # https://github.com/djcb/mu/issues/332
  test do
    (testpath/"cur").mkpath

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

    system bin/"mu", "init", "--muhome=#{testpath}", "--maildir=#{testpath}"
    system bin/"mu", "index", "--muhome=#{testpath}"

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
