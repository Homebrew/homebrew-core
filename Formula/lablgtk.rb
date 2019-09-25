class Lablgtk < Formula
  desc "Objective Caml interface to gtk+"
  homepage "http://lablgtk.forge.ocamlcore.org"
  url "https://github.com/garrigue/lablgtk/releases/download/lablgtk2188/lablgtk-2.18.8.tar.gz"
  sha256 "91f59bafd07989ea00080f4fd65512ce339878c7117bf5116bad3b93b64d4de3"

  bottle do
    cellar :any
    sha256 "82085a0b5c56b374b21170eef91f44ff7d5244dd26774a6e1f2c571f795ea539" => :mojave
    sha256 "752b24da7c440b036a47a32eb5342f588bb92017e9ba1d6a3416a54c9722a0ef" => :high_sierra
    sha256 "d67fbd9ba41211acbc4948a5dcbae98459cde16dc94211786e8c359f1f7158b1" => :sierra
  end

  depends_on "camlp4" => :build
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
