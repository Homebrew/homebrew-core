class Giza < Formula
  desc "Scientific plotting library for C/Fortran built on cairo"
  homepage "https://danieljprice.github.io/giza/"
  url "https://github.com/danieljprice/giza/releases/download/v2.0.0/giza-v2.0.0.tar.gz"
  sha256 "7cbdacc68ca2fc7f62f220ad6c12f8617d352bd27e06a752fb6c743c12fc0e1a"
  license "LGPL-3.0-only"
  head "https://github.com/danieljprice/giza.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e9b01959459db6e04fae1da95d9993467c0bb8d4dd60214666f486a3dd229a57"
    sha256 cellar: :any, arm64_tahoe:       "e9c2cd907eb467cc14f68afd5a9504aa06a817d619646473955305ff3b7643a7"
    sha256 cellar: :any, arm64_sequoia:     "a83b74a79c69db599a63fdc57e86c9ce376db34306bd40df1da07b7176c6134b"
    sha256 cellar: :any, arm64_sonoma:      "f92e5cfe5fb75a9e6c52f8cfd91b4cc752d242f770acdf1c66551c3143a95141"
    sha256 cellar: :any, arm64_linux:       "89f94ec520cea4e22e311b38ccd69dbeaddee15bd1d006d5665158873d62af52"
    sha256 cellar: :any, x86_64_linux:      "3710d5156b73bbeafb12b734e002066f68651087770454f67f65cbb6b3fc5fd1"
  end

  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gcc" # for gfortran
  depends_on "libx11"

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
