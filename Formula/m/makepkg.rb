class Makepkg < Formula
  desc "Compile and build packages suitable for installation with pacman"
  homepage "https://wiki.archlinux.org/index.php/makepkg"
  url "https://gitlab.archlinux.org/pacman/pacman.git",
      tag:      "v7.0.0",
      revision: "138cbae58448b7fde90335526add3029875784ee"
  license "GPL-2.0-or-later"
  head "https://gitlab.archlinux.org/pacman/pacman.git", branch: "master"

  bottle do
    sha256 arm64_sequoia:  "dd4038eb9b4f8d3928e251be3159e1af208a92f54b404412ac6b7a68f7fe03a7"
    sha256 arm64_sonoma:   "61faf5587194320721c0360027347b28d97c3ce0b157ff78504b9fbf8af28ccf"
    sha256 arm64_ventura:  "da4a03fa1256800c68b4d97faa71a8defd17e99afc9401c0c9882baf1db79dcb"
    sha256 arm64_monterey: "c6354bff149380a83c87fb59b6730fedb015407362e243be8e98736d14df50c4"
    sha256 sonoma:         "45597fa37e62ddd69aee401a4a9d34dc5ec1afdb367da9a1ed25035346462ed9"
    sha256 ventura:        "10997d0ff1dd13d24378863f421d1554c46502ebe5859f178df7055dc85f0ffe"
    sha256 monterey:       "b9b8be7872828bbb3da1488513d1a60a3b870f9880e2c929576da152e8cd230b"
    sha256 arm64_linux:    "57074a70ac1e5c270e4056174ce541e1e99f258a0a9f31f955ae3efdc8be84f8"
    sha256 x86_64_linux:   "77d749e913352e3d8b15a627f5368a267700fc25771476efe9749d9b5b5472a2"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "bash"
  depends_on "fakeroot"
  depends_on "libarchive"
  depends_on "openssl@3"

  uses_from_macos "m4" => :build
  uses_from_macos "python" => :build
  uses_from_macos "libxslt"

  on_sonoma :or_older do
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
