class Libgit2Glib < Formula
  desc "Glib wrapper library around libgit2 git access library"
  homepage "https://github.com/GNOME/libgit2-glib"
  url "https://download.gnome.org/sources/libgit2-glib/1.0/libgit2-glib-1.0.0.1.tar.xz"
  sha256 "460a5d6936950ca08d2d8518bfc90c12bb187cf6e674de715f7055fc58102b57"
  license "LGPL-2.1-only"
  revision 2
  head "https://github.com/GNOME/libgit2-glib.git", branch: "master"

  livecheck do
    url :stable
    regex(/libgit2-glib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "f1f3b03757ba84f3f6b69a01f3d222fa44bab33560658b941b78c99d0dd35e90"
    sha256 cellar: :any, arm64_monterey: "125c504581fd1b34aadab8cda48be795269e6af0c848944881db227bf9163243"
    sha256 cellar: :any, arm64_big_sur:  "692762f5a7741277fb886352e7d359dd115102b5d1827177a339bae58bf371ff"
    sha256 cellar: :any, ventura:        "e3a31913c1757e0d9a53fb6f7faf9a185e932cdfc447df59125ac0f3f9785f9c"
    sha256 cellar: :any, monterey:       "f931d7b629529e10ebf2f90fa0cc4029881f8338a04ea7918c77b0c326503089"
    sha256 cellar: :any, big_sur:        "3916e22446f0539587268585db1645c1d2e50dbe81a7a4f1e6b2c99c5b8e820a"
    sha256 cellar: :any, catalina:       "a90784d98e2f541feab44f465c2244412315ec75f5af6a179a183c6f33a9d109"
    sha256               x86_64_linux:   "f083f73ef071f7dbe11a419ec255511eb731a20d1421b280a2442db347266952"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "vala" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libgit2"

  def install
    mkdir "build" do
      ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"
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
