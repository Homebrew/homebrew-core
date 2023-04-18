class Giza < Formula
  desc "Scientific plotting library for C/Fortran built on cairo"
  homepage "https://danieljprice.github.io/giza/"
  url "https://github.com/danieljprice/giza/archive/v1.3.2.tar.gz"
  sha256 "080b9d20551bc6c6a779b1148830d0e89314c9a78c5a934f9ec8f02e8e541372"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/danieljprice/giza.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7d5f9228ef4c9555f1af7ffa60e3fe8dccfbb61dddb60ba70968c718112d9083"
    sha256 cellar: :any,                 arm64_monterey: "1a837d975f00941a008235124a59803141fefb8d10614582ce7802ea47a12a78"
    sha256 cellar: :any,                 arm64_big_sur:  "f78329c4aca9780496941516a59732ceeadfc0be526e1943dce7519a2ca561de"
    sha256 cellar: :any,                 ventura:        "d0832d92e5dc22310a01fafc89e4708185f4a3296f743f1df1451e354c7b84f5"
    sha256 cellar: :any,                 monterey:       "4edb315ea3a02c388550881052e35fa5ef04b312896e5fcb6be580b5f3b773f7"
    sha256 cellar: :any,                 big_sur:        "2fac6931d67da26fa46605ef00aa465e81437050e95e2d1960d05f5969383fe2"
    sha256 cellar: :any,                 catalina:       "5346d386325e486061bdde67c5d9ff826f0304e8b71b2a5355e5a92f41330923"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff1e1f486bbe66c1e80c394e6d6e0e92b447306dcbbad5406ff020980ce1a863"
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
