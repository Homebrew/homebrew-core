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
    sha256 cellar: :any, arm64_big_sur: "ea30f5120d215e4c9d97a8f112c133569474ab5a200bb7aad73a85d8ad9e7f87"
    sha256 cellar: :any, big_sur:       "a88c609f097bd8afa244f9f2a7dc45d4a5284c957cd9bbdf7a3311ff2bfc2f59"
    sha256 cellar: :any, catalina:      "7f446c1a120e41b442eb68e1fe25c25d5cba3cbd6068341797d42f716c951e8d"
    sha256 cellar: :any, mojave:        "bf08ec07b8a084946425abc689004bc2b0e5bb2a3f0d985e62c8e37260ca5602"
    sha256               x86_64_linux:  "77ff821a413cbb2dc9752a10684628ddbf88ab3699a0f9325d552f81afa7ceb7"
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
