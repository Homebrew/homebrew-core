class Lablgtk < Formula
  desc "Objective Caml interface to gtk+"
  homepage "http://lablgtk.forge.ocamlcore.org"
  url "https://github.com/garrigue/lablgtk/archive/2.18.11.tar.gz"
  sha256 "ff3c551df4e220b0c0fb9a3da6429413bff14f8fc93f4dd6807a35463982c863"
  license "LGPL-2.1"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any
    sha256 "597788b6c0736a9ef41a660fec64191b4c4556239fca28495b44099cd846a573" => :big_sur
    sha256 "e544b612c7067d60de3c58df5cc48f08ac32266dce56ef72a50b4895a841d21f" => :catalina
    sha256 "ff8fd335cb687977105f9b18efabc78abafa5965aafce64733888c0f035f92ae" => :mojave
    sha256 "127d47f712f5f0d914be06a87fa96344eaee9166cba08c50793cc28a8fef02dc" => :high_sierra
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
