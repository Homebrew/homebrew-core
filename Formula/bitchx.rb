class Bitchx < Formula
  desc "Text-based, scriptable IRC client"
  homepage "https://bitchx.sourceforge.io/"
  license "BSD-3-Clause"
  revision 1
  head "https://git.code.sf.net/p/bitchx/git.git", branch: "master"

  stable do
    url "https://downloads.sourceforge.net/project/bitchx/ircii-pana/bitchx-1.2.1/bitchx-1.2.1.tar.gz"
    sha256 "2d270500dd42b5e2b191980d584f6587ca8a0dbda26b35ce7fadb519f53c83e2"

    # Apply these upstream commits to fix Linux build:
    # https://sourceforge.net/p/bitchx/git/ci/1c6ff3088ad01a15bea50f78f1b2b468db7afae9/
    # https://sourceforge.net/p/bitchx/git/ci/4f63d4892995eec6707f194b462c9fc3184ee85d/
    # Remove with next release.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/7a83dbb5d8e3a3070ff80a28d396868cdd6b23ac/bitchx/linux.patch"
      sha256 "99caa10f32bfe4727a836b8cc99ec81e3c059729e4bb90641be392f4e98255d9"
    end
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "13c3a23d3e7316d509646ddbd5ee5442c096856124a4f2cc9123afee2ab66bfd"
    sha256 arm64_monterey: "2176f208cf2ef65ebe0fc9ea27d2581e21450a01f2b399aba4d0620085245bc2"
    sha256 arm64_big_sur:  "e92a812a3fdb12ef256f677a923b1343bd9a478beb41c988ea36845e6e154d75"
    sha256 ventura:        "c793d5d32ff5b4bb73d9c33f12b047459245ecc9f80883c66fac3ae9a30e2f6e"
    sha256 monterey:       "60c248c5f1b0a85a655ec9462b28982c4c0a089babdac242aedf9e0313a36f8e"
    sha256 big_sur:        "fb716a19bd25719a59a53270eb4dd4087d11946f44fe2a7adde6aeee183917fd"
    sha256 catalina:       "ea43f6d0776072e4a73f77621b676920c7a85c0b35446e29d61612c2e68d1ce8"
    sha256 x86_64_linux:   "99bec310978096fc74fb480bd558108eb6f9a476ce0dc6721c84a5023f6913c4"
  end

  depends_on "openssl@3"

  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"

  def install
    plugins = %w[
      acro arcfour amp autocycle blowfish cavlink encrypt
      fserv hint identd nap pkga possum qbx qmail
    ]

    # Remove following in next release
    if build.stable?
      # AIM plugin was removed upstream:
      # https://sourceforge.net/p/bitchx/git/ci/35b1a65f03a2ca2dde31c9dbd77968587b6027d3/
      plugins << "aim"

      # Patch to fix OpenSSL detection with OpenSSL 1.1
      # A similar fix is already committed upstream:
      # https://sourceforge.net/p/bitchx/git/ci/184af728c73c379d1eee57a387b6012572794fa8/
      inreplace "configure", "SSLeay", "OpenSSL_version_num"
    end

    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--enable-ipv6",
                          "--with-plugins=#{plugins.join(",")}",
                          "--with-ssl"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"BitchX", "-v"
  end
end
