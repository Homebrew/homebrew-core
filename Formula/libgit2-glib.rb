class Libgit2Glib < Formula
  desc "Glib wrapper library around libgit2 git access library"
  homepage "https://github.com/GNOME/libgit2-glib"
  url "https://download.gnome.org/sources/libgit2-glib/1.0/libgit2-glib-1.0.0.1.tar.xz"
  sha256 "460a5d6936950ca08d2d8518bfc90c12bb187cf6e674de715f7055fc58102b57"
  license "LGPL-2.1-only"
  revision 1
  head "https://github.com/GNOME/libgit2-glib.git", branch: "master"

  livecheck do
    url :stable
    regex(/libgit2-glib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "08421c08400b85111be6874010ce74947521a74cedb09c55d439d3d422592bae"
    sha256 cellar: :any, arm64_big_sur:  "530b3deff6ef24fe1a321506397ba429c78b94428f7bad5e4872de193a4e74de"
    sha256 cellar: :any, monterey:       "845aa584a3d3a5fd98962a6932a4335de2ac1360342afcf71e343a66707a4745"
    sha256 cellar: :any, big_sur:        "1b218cf212c7839c4600bc23de7d0b604ac4c6e1c556f4dbd7c8d6dceea14bf5"
    sha256 cellar: :any, catalina:       "8152d6025203f78acb73bb29ad95c4e102c6294d4f0d1731bd61a4c78613cef2"
    sha256               x86_64_linux:   "35959d73799fdc5052e3b7ac33b67e72176e0a084f8fc08bdd11dfc1c6b189dd"
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
