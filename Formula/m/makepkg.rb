class Makepkg < Formula
  desc "Compile and build packages suitable for installation with pacman"
  homepage "https://wiki.archlinux.org/index.php/makepkg"
  url "https://gitlab.archlinux.org/pacman/pacman.git",
      tag:      "v7.1.0",
      revision: "5683f8477a0afcc6b331766175a83445b2dcfe89"
  license "GPL-2.0-or-later"
  head "https://gitlab.archlinux.org/pacman/pacman.git", branch: "master"

  bottle do
    sha256               arm64_tahoe:   "437af5d09741dd52b5c010e56ad27ce2f44b9f04d6dad061d45086a5c99602d8"
    sha256               arm64_sequoia: "62fd3d7eec4486efe93fd2a8bdf99615efeaf778bb74e42682fb0b27115d348c"
    sha256               arm64_sonoma:  "a28ff22bdfcddb04c3d986464c29e69322faa7cb87f97838ec99eb71c8b9da7d"
    sha256 cellar: :any, sonoma:        "0b4e76c60d7475c0a11de8bc5aab08be1c88fcc234f5191d0cc159c76b954e15"
    sha256               arm64_linux:   "0efea1e4d153388446b13bcb72b22bbb54eea0edecba47e55884e3d452d4e716"
    sha256               x86_64_linux:  "997a27e40a380fa9cdc29efabc88cdf021b18c51b81ffe4fcfa4889ba8fea785"
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
