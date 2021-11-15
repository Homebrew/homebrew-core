class Lablgtk < Formula
  desc "Objective Caml interface to gtk+"
  homepage "http://lablgtk.forge.ocamlcore.org"
  url "https://github.com/garrigue/lablgtk/archive/2.18.11.tar.gz"
  sha256 "ff3c551df4e220b0c0fb9a3da6429413bff14f8fc93f4dd6807a35463982c863"
  license "LGPL-2.1"
  revision 3

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "684afad25502ebfcdb6c20d870590c98310de235efbde39c1b4950635b3d8f86"
    sha256 cellar: :any, monterey:      "65fa6135c87d0e578128c562a4d621451a92bec1262035edcfe8602e34fc41a3"
    sha256 cellar: :any, big_sur:       "5a7b9fb8ff6ac9d8ce0f952c59e5705f295849df5f00e10b4771f2edbd4fb056"
    sha256 cellar: :any, catalina:      "e9e7ed3fba9b4aea756fd38e46b178d9cbafd588fd4b6160683e08ba1ba2ae3a"
    sha256 cellar: :any, mojave:        "60ecd5b76592917ec79b3fd2851d655eac39f3c08b945f24d154e4743a16fca1"
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+"
  depends_on "gtksourceview"
  depends_on "librsvg"
  depends_on "ocaml"

  def install
    system "./configure", "--bindir=#{bin}",
                          "--libdir=#{lib}",
                          "--mandir=#{man}",
                          "--with-libdir=#{lib}/ocaml"
    ENV.deparallelize
    system "make", "world"
    system "make", "old-install"
  end

  test do
    (testpath/"test.ml").write <<~EOS
      let _ =
        GtkMain.Main.init ()
    EOS
    ENV["CAML_LD_LIBRARY_PATH"] = "#{lib}/ocaml/stublibs"
    system "ocamlc", "-I", "#{opt_lib}/ocaml/lablgtk2", "lablgtk.cma", "gtkInit.cmo", "test.ml", "-o", "test",
      "-cclib", "-latk-1.0",
      "-cclib", "-lcairo",
      "-cclib", "-lgdk-quartz-2.0",
      "-cclib", "-lgdk_pixbuf-2.0",
      "-cclib", "-lgio-2.0",
      "-cclib", "-lglib-2.0",
      "-cclib", "-lgobject-2.0",
      "-cclib", "-lgtk-quartz-2.0",
      "-cclib", "-lgtksourceview-2.0",
      "-cclib", "-lintl",
      "-cclib", "-lpango-1.0",
      "-cclib", "-lpangocairo-1.0"
    system "./test"
  end
end
