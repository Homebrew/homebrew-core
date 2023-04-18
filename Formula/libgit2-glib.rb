class Libgit2Glib < Formula
  desc "Glib wrapper library around libgit2 git access library"
  homepage "https://github.com/GNOME/libgit2-glib"
  url "https://download.gnome.org/sources/libgit2-glib/1.0/libgit2-glib-1.0.0.1.tar.xz"
  sha256 "460a5d6936950ca08d2d8518bfc90c12bb187cf6e674de715f7055fc58102b57"
  license "LGPL-2.1-only"
  revision 3
  head "https://github.com/GNOME/libgit2-glib.git", branch: "master"

  livecheck do
    url :stable
    regex(/libgit2-glib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "b30006198b771b53f422e82bd9ee182901377f53cb12074e50c086dafaf5816a"
    sha256 cellar: :any, arm64_monterey: "be1d0ce4dd8c25160c8f22e528ae31edd00e273d230b6c7ae1ade7279e809d97"
    sha256 cellar: :any, arm64_big_sur:  "b7cb5c1d6ffd664094cb7d541e05aacc2b21dc6d12389217dd37acc630f96489"
    sha256 cellar: :any, ventura:        "d580b6f2f45af85ff7672f08f9171f27f6af60f8754e51dc5d71a0d74270554d"
    sha256 cellar: :any, monterey:       "532651b558b63fcb13d917ed9a6d6ff70bdbf0f9c6bb62e82c1695a1d6eae776"
    sha256 cellar: :any, big_sur:        "6ad50fd6ef1550c2c6f46d695f8cf15dbdef83a90ddfa0d48701e6f46d910e94"
    sha256               x86_64_linux:   "bda1c02e3bbc93eddca94a575da7666f350f0548ae8fc168a9d664ca037aa1dc"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
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
