class Makepkg < Formula
  desc "Compile and build packages suitable for installation with pacman"
  homepage "https://wiki.archlinux.org/title/Makepkg"
  url "https://gitlab.archlinux.org/pacman/pacman.git",
      tag:      "v7.1.0",
      revision: "5683f8477a0afcc6b331766175a83445b2dcfe89"
  license "GPL-2.0-or-later"
  revision 1
  head "https://gitlab.archlinux.org/pacman/pacman.git", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "46c4fc96d53e976fe47de36b55f0c0ab4b7e59a1731dc8d087b568e39a3c3141"
    sha256 arm64_tahoe:       "72257a30b8c5f4bdf744c7023717c7b53bd8238bb23258b4620e8d6aee542de2"
    sha256 arm64_sequoia:     "ae487ee514831cd971255fc79129896725b3fddcba0934a01b73eba4f5f231de"
    sha256 arm64_linux:       "cdafd97a206d6872e741fc73edcfa7a45abe5323705687ec7d8904489f88d792"
    sha256 x86_64_linux:      "52299e04c1713384411d0ae6f65851ee7656f98ffe4e32a898c5783057d0eeca"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "bash" # bash >= 4.4.0. On Linux, only needed for RHEL 7 ELS (ends 2029-05-31)
  depends_on "fakeroot"
  depends_on "gettext" # runs gettext command
  depends_on "libarchive"
  depends_on "openssl@4"

  uses_from_macos "m4" => :build
  uses_from_macos "python" => :build
  uses_from_macos "curl"
  uses_from_macos "libxslt"

  on_sonoma :or_older do
    depends_on "coreutils" # for sha256sum
  end

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    args = %W[
      -Dmakepkg-template-dir=#{share}/makepkg-template
      -Dsysconfdir=#{etc}
      -Dlocalstatedir=#{var}
      -Ddoc=disabled
    ]
    args << "-Di18n=false" if OS.mac?

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    sha256 = "81d6c6a5cb77ba35b89c91004c04a907a1ca6b05de5c048655672f3478340471"
    (testpath/"PKGBUILD").write <<~EOS
      pkgname=androidnetworktester
      pkgname=test
      arch=('any')
      source=(https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/androidnetworktester/10kb.txt)
      pkgrel=0
      pkgver=0
      sha256sums=('#{sha256}')
    EOS
    assert_match "sha256sums=('#{sha256}')", shell_output("#{bin}/makepkg --nodeps --geninteg 2>&1")
  end
end
