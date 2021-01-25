class Libgit2Glib < Formula
  desc "Glib wrapper library around libgit2 git access library"
  homepage "https://github.com/GNOME/libgit2-glib"
  url "https://download.gnome.org/sources/libgit2-glib/0.99/libgit2-glib-0.99.0.1.tar.xz"
  sha256 "e05a75c444d9c8d5991afc4a5a64cd97d731ce21aeb7c1c651ade1a3b465b9de"
  license "LGPL-2.1"
  revision 2
  head "https://github.com/GNOME/libgit2-glib.git"

  livecheck do
    url :stable
    regex(/libgit2-glib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "bffdfd6183ae4bdb486f40f9a449ab0582387b40be36c356ce6f83642011bec7" => :big_sur
    sha256 "335de71224cede561e05645cde3709acf3763e168d2da11b13586d3c3605d67e" => :catalina
    sha256 "308f244da46a0a70ab9e1fb9cf2eae8dd24e26c363b344f5872f5ee65ef9043a" => :mojave
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libgit2"

  def install
    mkdir "build" do
      system "meson", *std_meson_args,
                      "-Dpython=false",
                      "-Dvapi=true",
                      ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
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
