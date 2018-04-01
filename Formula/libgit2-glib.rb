class Libgit2Glib < Formula
  desc "Glib wrapper library around libgit2 git access library"
  homepage "https://github.com/GNOME/libgit2-glib"
  url "https://download.gnome.org/sources/libgit2-glib/0.26/libgit2-glib-0.26.4.tar.xz"
  sha256 "97610e42427a0c86ac46b89d5020fb8decb39af47b9dc49f8d078310b4c21e5a"
  head "https://github.com/GNOME/libgit2-glib.git"

  bottle do
    sha256 "2e125fec26f3e5ea1b8db35940253f0f1a27e995885351cb2ab3e8a790b2e75c" => :high_sierra
    sha256 "b751e4b7517e0744633ce489a4cfc19d170b315361f5a089264e385126f2d8ea" => :sierra
    sha256 "ca9e00d2c139d09f9a4ea9b0cd5e45a54804cb22ccf1d8828c871917e71ce91e" => :el_capitan
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson-internal" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libgit2"
  depends_on "glib"

  def install
    ENV.refurbish_args

    # Fix "ld: unknown option: -Bsymbolic-functions"
    # Reported 2 Apr 2018 https://bugzilla.gnome.org/show_bug.cgi?id=794889
    inreplace "libgit2-glib/meson.build",
              "libgit2_glib_link_args = [ '-Wl,-Bsymbolic-functions' ]",
              "libgit2_glib_link_args = []"

    mkdir "build" do
      system "meson", "--prefix=#{prefix}",
                      "-Dpython=false",
                      "-Dvapi=false",
                      ".."
      system "ninja"
      system "ninja", "install"
      libexec.install Dir["examples/*"]
    end
  end

  test do
    mkdir "horatio" do
      system "git", "init"
    end
    system "#{libexec}/general", testpath/"horatio"
  end
end
