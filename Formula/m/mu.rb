# NOTE: Odd release numbers indicate unstable releases.
# Please only submit PRs for [x.even.x] version numbers:
# https://github.com/djcb/mu/commit/23f4a64bdcdee3f9956a39b9a5a4fd0c5c2370ba
class Mu < Formula
  desc "Tool for searching e-mail messages stored in the maildir-format"
  homepage "https://www.djcbsoftware.nl/code/mu/"
  url "https://github.com/djcb/mu/releases/download/v1.12.6/mu-1.12.6.tar.xz"
  sha256 "f8a539b687c999678fd7cd37cc4ab15ee5e87801027d982ba195b3a9cb53b761"
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
    sha256 cellar: :any, arm64_sequoia:  "45155d92040b72dcc56696539a31ef8256eda650ad4566f09b825d977242ef30"
    sha256 cellar: :any, arm64_sonoma:   "ed4d895407f56e18649323d631f1ac9a2b0829e3c4760c94a0dedd4ac276e848"
    sha256 cellar: :any, arm64_ventura:  "744f9257dffb1fb1b91830f196053277eaf21fdd3c64c2bbd5276b047e73af51"
    sha256 cellar: :any, arm64_monterey: "b1fd957c5632c2be1fbd11e8c80c0515f238bba508e153780c374df692fdd00d"
    sha256 cellar: :any, sonoma:         "7f6de42add1b3fcf5ab61834f8a711704d620de2f591a6be47bd37e7814f1cb0"
    sha256 cellar: :any, ventura:        "08646f67ee4e951b576fd509ad1674271df6a1f4f401bf742720e44e4da349a7"
    sha256 cellar: :any, monterey:       "40b5c936a5ec11df7713ec71d6e294bfb9ae1277a498ee03b6d841d68fb02fbd"
    sha256               x86_64_linux:   "e6a5eba6771253822c8b167942045bb04c99e90074d28144c3fb88faae8cefb2"
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
