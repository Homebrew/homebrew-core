class Libgit2Glib < Formula
  desc "Glib wrapper library around libgit2 git access library"
  homepage "https://github.com/GNOME/libgit2-glib"
  url "https://download.gnome.org/sources/libgit2-glib/0.26/libgit2-glib-0.26.4.tar.xz"
  sha256 "97610e42427a0c86ac46b89d5020fb8decb39af47b9dc49f8d078310b4c21e5a"
  head "https://github.com/GNOME/libgit2-glib.git"

  bottle do
    sha256 "3f54034bdc3f924e2755c7b70237bcca02d4360d40dd078f515636f5d76ad37a" => :high_sierra
    sha256 "24e9475134d69efaa3b4da3e993040af6c31ac790167d779c3b8700009f021c6" => :sierra
    sha256 "7d29be8d0f0c8275a0d5d7a2cbb7bb68375f4476b2a1776f6e05f0902db10f04" => :el_capitan
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
