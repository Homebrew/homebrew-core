class Libgda < Formula
  desc "Provides unified data access to the GNOME project"
  homepage "https://www.gnome-db.org/"
  url "https://download.gnome.org/sources/libgda/6.0/libgda-6.0.0.tar.xz"
  sha256 "995f4b420e666da5c8bac9faf55e7aedbe3789c525d634720a53be3ccf27a670"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_big_sur: "993a414772b41e1f0b2cffe21f9af240dbcd7e2b6de5d62a0e51b89a8144e40a"
    sha256 big_sur:       "1fd18afa48f013fcee08cadebf89c4bbb3e37444b591b16cd61e5848b93d6395"
    sha256 catalina:      "83d65ccf6e92620dd833dd23d1a02880f020ab24a0a6ed2ab5cb1a5149a32c5b"
    sha256 mojave:        "e48a5aea9d860765e58bcd756c8e81956974d4284189604755a63232fc13a806"
    sha256 high_sierra:   "8c9a8133c1fd1c554f995c089b12cbe049d2a8a01ac31cb5e68c089857a200a1"
  end

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "iso-codes"
  depends_on "json-glib"
  depends_on "openssl@1.1"
  depends_on "sqlite"

  def install
    system "meson", "builddir", *std_meson_args, "-Djson=true", "-Dsqlcipher=false"
    system "meson", "compile", "-C", "builddir"
    system "meson", "install", "-C", "builddir"

    # Install unversioned symlinks
    include.install_symlink include/"libgda-#{version.major_minor}/libgda" => "libgda"
    lib.install_symlink lib/shared_library("libgda-#{version.major_minor}") => shared_library("libgda")

    pkgshare.install "examples"
  end

  test do
    example = pkgshare/"examples/SimpleExample/example.c"
    pkgconfig = Formula["pkg-config"].opt_bin/"pkg-config"
    pc_cflags = Utils.safe_popen_read(pkgconfig, "--cflags", "libgda-#{version.major_minor}").split
    pc_cflags << "-I#{Formula["sqlite"].include}"
    pc_libs = Utils.safe_popen_read(pkgconfig, "--libs", "libgda-#{version.major_minor}").split
    pc_libs += %W[-L#{Formula["sqlite"].lib} -lsqlite3]
    system ENV.cc, *pc_cflags, *pc_libs, example, "-o", "test"
    system "./test"
  end
end
