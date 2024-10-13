class Giza < Formula
  desc "Scientific plotting library for C/Fortran built on cairo"
  homepage "https://danieljprice.github.io/giza/"
  url "https://github.com/danieljprice/giza/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "67c8eba2cc44a4eb16ff89b10147fa1a157be5801668391726200735c522faf7"
  license "LGPL-3.0-only"
  head "https://github.com/danieljprice/giza.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "fa14dd38b5754c4b39efc904b9ec559e4d1efc9d93af47ec48c6dde4fd2c6dfd"
    sha256 cellar: :any,                 arm64_sonoma:   "22cb653beed8d13da143eb46eb02c85923f512a59f28301cbad9d3d3fc461393"
    sha256 cellar: :any,                 arm64_ventura:  "033d6270f86668e5400734f04b1d35dbeaac4ebeb66179ecb679a4a29af0f1fe"
    sha256 cellar: :any,                 arm64_monterey: "3cae4c7547de87c4dea58f0c10581b4419676a70a52791fbaaeade23617dd404"
    sha256 cellar: :any,                 sonoma:         "0a9de6e1beb8f7d26b3da09236d5f3d072548ad95e44b3a9ece430e88d4bef75"
    sha256 cellar: :any,                 ventura:        "3ffc862d71532358649df9236f1e25f6889ccd6d16e16fda16881db6e7ac22f8"
    sha256 cellar: :any,                 monterey:       "59f5440bf93bb86b074965904d9baaeca01e44d4825c71059085a7f8e44b84c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d59a3cb64df7fae5c3b094273d6dcfd0b455e05216bf251b0b116b8a4f0e3dfc"
  end

  depends_on "pkg-config" => :build

  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gcc" # for gfortran
  depends_on "libx11"

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"

    # Clean up stray Makefiles in test folder
    makefiles = File.join("test", "**", "Makefile*")
    Dir.glob(makefiles).each do |file|
      rm file
    end

    prefix.install "test"
  end

  def caveats
    <<~EOS
      Test suite has been installed at:
        #{opt_prefix}/test
    EOS
  end

  test do
    test_dir = "#{prefix}/test/C"
    cp_r test_dir, testpath

    flags = %W[
      -I#{include}
      -I#{Formula["cairo"].opt_include}/cairo
      -L#{lib}
      -L#{Formula["libx11"].opt_lib}
      -L#{Formula["cairo"].opt_lib}
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
      system ENV.cc, testpath/"C"/file, *flags
    end
  end
end
