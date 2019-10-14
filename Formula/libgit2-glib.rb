class Libgit2Glib < Formula
  desc "Glib wrapper library around libgit2 git access library"
  homepage "https://github.com/GNOME/libgit2-glib"
  url "https://download.gnome.org/sources/libgit2-glib/0.28/libgit2-glib-0.28.0.1.tar.xz"
  sha256 "e70118481241a841d5261bdd4caa3158b2ffcb5ccf9d4f32b6cf6563b83a0f28"
  head "https://github.com/GNOME/libgit2-glib.git"

  bottle do
    sha256 "207156e6776f3c33dc2b3d3360c4d07b6ff06d63eecd1307c3e890b9192e1179" => :catalina
    sha256 "f82b96ed9c95745467ee9aff18b2d6ba0156d51f68801a781bee67d6b2b2923a" => :mojave
    sha256 "0b66cc16cda70882208b1f82be0a715fb3994054ea336c847e78189eb09dee97" => :high_sierra
    sha256 "e05260bd33fb4ff96ba9669ab65930bef977219bc455717ca6bdd97eb77e3bd6" => :sierra
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
      system "meson", "--prefix=#{prefix}",
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
