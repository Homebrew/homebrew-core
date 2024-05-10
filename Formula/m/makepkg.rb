class Makepkg < Formula
  desc "Compile and build packages suitable for installation with pacman"
  homepage "https://wiki.archlinux.org/index.php/makepkg"
  url "https://gitlab.archlinux.org/pacman/pacman.git",
      tag:      "v6.1.0",
      revision: "e3dc296ba35d5039775c6e53decc7296b3bce396"
  license "GPL-2.0-or-later"
  head "https://gitlab.archlinux.org/pacman/pacman.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "507a4c1078a9b109dc69a3376188e396dc63ac1d7c3ef0d5ba69e577686c22a3"
    sha256 arm64_ventura:  "0761fe2e513cd94f1267c42f8dd2c30f50dc34c02a58027f898a9f5977325de3"
    sha256 arm64_monterey: "17e26d19bf6c950e24a45755ce059efce96c0864e2482b80aeb1e68fbd542f4d"
    sha256 sonoma:         "1e9d79566f1c0663e16676def8a90a60c9608c0abfa979a0bcde8acac5ff4458"
    sha256 ventura:        "5ff1e558f4c860612fa62b4586ba8c902332dc2281c797a7b3a3861aa704dd8e"
    sha256 monterey:       "b4a77ae7d873d791b36e2076de5174d52c7778e7d80988c668d6d581ca02f95f"
    sha256 x86_64_linux:   "99b6ebb40225e1fdad4fcb9fcc1ed0a00301e77368da6689f36c2176d4c6f804"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "bash"
  depends_on "fakeroot"
  depends_on "libarchive"
  depends_on "openssl@3"

  uses_from_macos "m4" => :build
  uses_from_macos "python" => :build
  uses_from_macos "libxslt"

  on_macos do
    depends_on "coreutils" => :test # for md5sum
  end

  on_linux do
    depends_on "gettext"
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
    (testpath/"PKGBUILD").write <<~EOS
      pkgname=androidnetworktester
      pkgname=test
      source=(https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/androidnetworktester/10kb.txt)
      pkgrel=0
      pkgver=0
      md5sums=('e232a2683c04881e292d5f7617d6dc6f')
    EOS
    assert_match "md5sums=('e232a2683c0", pipe_output("#{bin}/makepkg -dg 2>&1")
  end
end
