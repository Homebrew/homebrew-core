class Lablgtk < Formula
  desc "Objective Caml interface to gtk+"
  homepage "https://github.com/garrigue/lablgtk"
  url "https://github.com/garrigue/lablgtk/archive/refs/tags/2.18.12.tar.gz"
  sha256 "43b2640b6b6d6ba352fa0c4265695d6e0b5acb8eb1da17290493e99ae6879b18"
  license "LGPL-2.1-or-later" => { with: "OCaml-LGPL-linking-exception" }
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sonoma:   "b0af5ac1cd4cca8509ecdc7feb0fddef63c2a197d26a8e84a8b4b58f7eee73eb"
    sha256 cellar: :any, arm64_ventura:  "7cb01bef4d60ce7f596ad6f3adc5923d749ead4b59588b543138b1f66b74a2a6"
    sha256 cellar: :any, arm64_monterey: "2c21ec6b8830ee50288760db11028d09ae3b044f3c13b88ff994d4216b1f0ed9"
    sha256 cellar: :any, arm64_big_sur:  "65cfbb0af55509b9b7510f326f5b88f63f9d3a3df0977d93f065d9ef043c7425"
    sha256 cellar: :any, sonoma:         "e8320c459ec008f4b868f81aa7ecdfcc44f16eb09d634fb594f5299536377a21"
    sha256 cellar: :any, ventura:        "2201dac36a46692e3528faeb8b13bddbf211bac47751ee78a129292eb6a48e51"
    sha256 cellar: :any, monterey:       "1e26236878d78e09830714ac7367843aa0de50aaee48946958dbb795e6d27e2e"
    sha256 cellar: :any, big_sur:        "b934fef88127a297467f7dcb144fe7e3c60d169da70c45e7ac63cccf03dc2a6e"
    sha256               x86_64_linux:   "1e5f02345d7be4fdfa1ab57097b866248c0e9f8465f751a526909870cbeb926b"
  end

  # GTK 2 is EOL: https://blog.gtk.org/2020/12/16/gtk-4-0/
  # GTK 3 supported package is named `lablgtk3` so may be better as separate formula
  disable! date: "2024-01-21", because: :unmaintained

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
    cclibs = [
      "-cclib", "-latk-1.0",
      "-cclib", "-lcairo",
      "-cclib", "-lgdk-quartz-2.0",
      "-cclib", "-lgdk_pixbuf-2.0",
      "-cclib", "-lgio-2.0",
      "-cclib", "-lglib-2.0",
      "-cclib", "-lgobject-2.0",
      "-cclib", "-lgtk-quartz-2.0",
      "-cclib", "-lgtksourceview-2.0",
      "-cclib", "-lpango-1.0",
      "-cclib", "-lpangocairo-1.0"
    ]
    cclibs += ["-cclib", "-lintl"] if OS.mac?
    system "ocamlc", "-I", "#{opt_lib}/ocaml/lablgtk2", "lablgtk.cma", "gtkInit.cmo", "test.ml",
           "-o", "test", *cclibs
    # Disable this part of the test because display is not available on Linux.
    system "./test" if OS.mac?
  end
end
