class Giza < Formula
  desc "Scientific plotting library for C/Fortran built on cairo"
  homepage "https://danieljprice.github.io/giza/"
  url "https://github.com/danieljprice/giza/releases/download/v2.0.2/giza-v2.0.2.tar.gz"
  sha256 "2dc801eb976ab28d083cb41b5e4dc595c4d956d9fed173c5d76fcf29eca0210d"
  license "LGPL-3.0-only"
  head "https://github.com/danieljprice/giza.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "bace3a6c060d0cf27fe083ce67c0411e7c95a857f62c87bc2dbee8651b3dfc89"
    sha256 cellar: :any, arm64_tahoe:       "aedfa2ec4113e16783808da789e4694a454c27f9d97625bccc753da91b0a21a6"
    sha256 cellar: :any, arm64_sequoia:     "ce32cb992f9273f6794ac62fdbb885e2c75093e27857bf1dedc8b628cd0b8970"
    sha256 cellar: :any, arm64_linux:       "08cbfd00229cf6258d3a7e2b535ae7a106cccebea8d836ed8c99fe4dea3a4ae4"
    sha256 cellar: :any, x86_64_linux:      "b86531a6ed5276eb486542eedcb26dbb82087f4508b0ff5d2fc2a7d665ca02b7"
  end

  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gcc" # for gfortran
  depends_on "libx11"

  deny_network_access!

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"

    # Install test files to use during `brew test`
    rm(Dir["test/**/Makefile*"])
    prefix.install "test"
  end

  test do
    cp_r prefix/"test/C/.", testpath

    flags = %W[
      -I#{include}
      -I#{formula_opt_include("cairo")}/cairo
      -L#{lib}
      -L#{formula_opt_lib("libx11")}
      -L#{formula_opt_lib("cairo")}
      -lX11
      -lcairo
      -lgiza
    ]

    %w[
      test-XOpenDisplay.c
      test-cairo-xw.c
      test-giza-xw.c
      test-rectangle.c
      test-window.c
    ].each do |file|
      system ENV.cc, file, *flags
    end
  end
end
