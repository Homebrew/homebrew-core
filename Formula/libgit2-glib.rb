class Libgit2Glib < Formula
  desc "Glib wrapper library around libgit2 git access library"
  homepage "https://github.com/GNOME/libgit2-glib"
  url "https://download.gnome.org/sources/libgit2-glib/0.28/libgit2-glib-0.28.0.1.tar.xz"
  sha256 "e70118481241a841d5261bdd4caa3158b2ffcb5ccf9d4f32b6cf6563b83a0f28"
  head "https://github.com/GNOME/libgit2-glib.git"

  bottle do
    sha256 "2a8850fb76314cbb73134d4c2fc73a745fe4bb3b5ebc889d902ffb70e9b104b4" => :mojave
    sha256 "6ca7108fd8a692ba5a9ebc480f9bb49b33bc0a154057e595a40baa543690bade" => :high_sierra
    sha256 "0d44665ecaa51f237ed56445dd415833addc1be0b95b33f069d47b23fcd55cee" => :sierra
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
