# NOTE: Odd release numbers indicate unstable releases.
# Please only submit PRs for [x.even.x] version numbers:
# https://github.com/djcb/mu/commit/23f4a64bdcdee3f9956a39b9a5a4fd0c5c2370ba
class Mu < Formula
  desc "Tool for searching e-mail messages stored in the maildir-format"
  homepage "https://www.djcbsoftware.nl/code/mu/"
  url "https://github.com/djcb/mu/releases/download/v1.10.7/mu-1.10.7.tar.xz"
  sha256 "eaaac9ba515da232295b03f2797eed13552fdd29a30122134dd382a64d0d3c21"
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
    sha256 arm64_sonoma:   "c97506909d083544aecf575289b5b38f5911c60eca4121fed4959a86d7da3a28"
    sha256 arm64_ventura:  "bc90dc1e9f62e2acf71ceb7094417b25683a399d4fe7e26a69097c6bdc95f16a"
    sha256 arm64_monterey: "e4ac32f4f8a9bddc3f2bfc52a23d186371fa270af83b4f90412fd8a63587af11"
    sha256 arm64_big_sur:  "7181dbc47760b649d561e9c6093810177df8d07877ac7e739150dd24ea1c49cf"
    sha256 sonoma:         "032f874677bdbf478900b2665d12fb97dabe9d62302e57332afae8dfa3f83e68"
    sha256 ventura:        "d0b69037da3168e252d43659af5af418bcfe87a305d4fc9edc83d456b481f9aa"
    sha256 monterey:       "c7308c82ae928c4f2c5e9385c671318edd1a77b3d2ee7530fd7f6e7b93bda635"
    sha256 big_sur:        "58ee12b5f75b81f23a0f29f8f4c44bd81e9b151fb3968ff4cd44cfdd5bd473f7"
    sha256 x86_64_linux:   "2511719b6f1ac7b9e7fce329afe712c074ead932b1b3ad058e1ad02291ade7c5"
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
-  install_dir: guile_extension_dir
-)
+  install: true)

 if makeinfo.found()
   custom_target('mu_guile_info',
