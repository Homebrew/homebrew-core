class Libgit2Glib < Formula
  desc "Glib wrapper library around libgit2 git access library"
  homepage "https://github.com/GNOME/libgit2-glib"
  url "https://download.gnome.org/sources/libgit2-glib/0.99/libgit2-glib-0.99.0.1.tar.xz"
  sha256 "e05a75c444d9c8d5991afc4a5a64cd97d731ce21aeb7c1c651ade1a3b465b9de"
  license "LGPL-2.1"
  revision 4
  head "https://github.com/GNOME/libgit2-glib.git"

  livecheck do
    url :stable
    regex(/libgit2-glib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "14f4f4a3b09727ca9993953c5fa7e0b9d0dd991cd9f782cdd42d254e6317b974"
    sha256 cellar: :any, big_sur:       "88a012ad27e2056c313cad08039c2c2ac534ff6f383baae09363b357fcbf5e7e"
    sha256 cellar: :any, catalina:      "804db5cc23243985293b05e7ab18c54a52e36cb4f339c5d9bbaaee5ac6ebdd39"
    sha256 cellar: :any, mojave:        "bf0aacd695af9b723be16caaba4252e87bb1001ff4710872d4b5eceff7efe8f5"
    sha256               x86_64_linux:  "95b4558001af9d732a9d9ab29bcb0cc096af93f7b495e196db9fb0b16a9f399a"
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
