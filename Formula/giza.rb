class Giza < Formula
  desc "Scientific plotting library for C/Fortran built on cairo"
  homepage "https://danieljprice.github.io/giza/"
  url "https://github.com/danieljprice/giza/archive/v1.3.1.tar.gz"
  sha256 "b6bae5ba44a8fd921c3430e61b1ce5c6b7febfe7fa835a7c8724d19089bba0b9"
  license "GPL-2.0-or-later"
  head "https://github.com/danieljprice/giza.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d975aae84df1d51b437f4609fedb6e2c43d90a607e71a6a00d93ec93e23300dc"
    sha256 cellar: :any,                 arm64_big_sur:  "399cb433ec96d5ee36c0e17cc5827630648b75f5ca47606b51ce15032f71222f"
    sha256 cellar: :any,                 monterey:       "7b103ac9d9567889e610823092cac1cab927522a3e9e4b5aa93d2ed811b4ba27"
    sha256 cellar: :any,                 big_sur:        "ba70ab58bd3ed8ac5491b00547c30b1ec728b4324a1fb01ef6ebdbf5f2cf17e5"
    sha256 cellar: :any,                 catalina:       "0e60f22c26465fe0971cc4df08d79ac30fe886dde744bf77877af6180d87ca41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "708726ce009cb5618c3550b211179706ab7dd674f7274d95047ee1874c2e39b0"
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "gcc" # for gfortran
  depends_on "libx11"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
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
