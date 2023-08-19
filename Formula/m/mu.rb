# NOTE: Odd release numbers indicate unstable releases.
# Please only submit PRs for [x.even.x] version numbers:
# https://github.com/djcb/mu/commit/23f4a64bdcdee3f9956a39b9a5a4fd0c5c2370ba
class Mu < Formula
  desc "Tool for searching e-mail messages stored in the maildir-format"
  homepage "https://www.djcbsoftware.nl/code/mu/"
  url "https://github.com/djcb/mu/releases/download/v1.10.6/mu-1.10.6.tar.xz"
  sha256 "3c45b72ad5de350c8ff6e1ad19a3cb868719cfc3e65c3427797e757d6eff18d6"
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
    sha256 arm64_ventura:  "81f1e70c20875e92a3f431746e7373e9088428870f435929136b887df72d7f06"
    sha256 arm64_monterey: "5d1671287275d822a3c101466f4b9cb1099e5edade871a364eccac1c9617e92f"
    sha256 arm64_big_sur:  "30faf5ef8dd448bbcbe680ebf8954bdc587752e10082ed2d24c4f14084a41258"
    sha256 ventura:        "d85d7c499c099b62c68c6a5646ff8a440dc190c8b3df174d7758423b092a4f7d"
    sha256 monterey:       "d34b8d54ab20d14960aef7698fc95a57ce25d682202b61cffddaa5a1d31d470c"
    sha256 big_sur:        "2377c67a64adbe6583ab98c342ae2909c1ea17ead499908a13ccf69c1c38b152"
    sha256 x86_64_linux:   "56efa3b5c5368b8b1a77c7430aae13a254d837748d142502268c1ca697aa1a1b"
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

  # upstream bug report, https://github.com/djcb/mu/issues/2531
  # reverts https://github.com/djcb/mu/pull/2522
  patch :DATA

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

__END__
diff --git a/guile/meson.build b/guile/meson.build
index 933553c..ca051d1 100644
--- a/guile/meson.build
+++ b/guile/meson.build
@@ -73,9 +73,7 @@ lib_guile_mu = shared_module(
   [ 'mu-guile.cc',
     'mu-guile-message.cc' ],
   dependencies: [guile_dep, glib_dep, lib_mu_dep, config_h_dep, thread_dep ],
-  install: true,
-  install_dir: guile_dep.get_variable(pkgconfig: 'extensiondir')
-)
+  install: true)

 if makeinfo.found()
   custom_target('mu_guile_info',
