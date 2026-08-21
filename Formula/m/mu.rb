# NOTE: Odd release numbers indicate unstable releases.
# Please only submit PRs for [x.even.x] version numbers:
# https://github.com/djcb/mu/commit/23f4a64bdcdee3f9956a39b9a5a4fd0c5c2370ba
class Mu < Formula
  desc "Tool for searching e-mail messages stored in the maildir-format"
  homepage "https://www.djcbsoftware.nl/code/mu/"
  url "https://github.com/djcb/mu/releases/download/v1.14.3/mu-1.14.3.tar.xz"
  sha256 "edea1a4e6be390a2bf5260e0156813f9b473c2d91da934b219dbb38229b0930a"
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
    sha256 arm64_tahoe:   "cbdefd2848e92bd6b2e2b8e5c55cd17771e6d0407e03560022339206b2e72c83"
    sha256 arm64_sequoia: "88bf9d1ff9585cc80194c20926a048dca747d1746432487bb4320a2e3072b44a"
    sha256 arm64_sonoma:  "4003872b02902f4f7eb9ad8c29943f71fd3d63d370b65d69724c4057a9cf525b"
    sha256 sonoma:        "f82605595d247fb5a7ef14020f4ce7233197107c59241575576baea7b70e4cba"
    sha256 arm64_linux:   "678d7927d82e17ba7e043f9fe67e0ba69978e0d73c90303a3e4dadb899e5be81"
    sha256 x86_64_linux:  "7d03f1d73cf4eae88218d2a0eec4a0fbc7c8a924298fd1801b60a2e6f879425c"
  end

  depends_on "cli11" => :build
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
