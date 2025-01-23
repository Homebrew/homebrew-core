class Giza < Formula
  desc "Scientific plotting library for C/Fortran built on cairo"
  homepage "https://danieljprice.github.io/giza/"
  url "https://github.com/danieljprice/giza/archive/refs/tags/v1.4.4.tar.gz"
  sha256 "cbd25427b52ffbf87ae7a54aea906f9fab55ed7773857a9b2f724efd79923de1"
  license "LGPL-3.0-only"
  head "https://github.com/danieljprice/giza.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7aee9fc789a50a7b402e9166e06a06bfd76414493ad80df18b0b4ade8d32f77f"
    sha256 cellar: :any,                 arm64_sonoma:  "67971fd27cc7e40d5f98754836ef42dcb4ef1c0ddf66331f0d21e26207257bdb"
    sha256 cellar: :any,                 arm64_ventura: "4a3c0833ec4b3e8a6431418eb094d105cd2e2df86af4dbf7c0528895b16b1aae"
    sha256 cellar: :any,                 sonoma:        "c4ed0b1ac1908380e160dd5a16ec08e8a9e9043bad61c027aa58cbe4674307ce"
    sha256 cellar: :any,                 ventura:       "1ccfaacf89c4afeabb14a61e4fea79c6912d7b0d0f50e7aa0f006aedf867d490"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a531fc97b0597105115166b51577526bd9f4d23a7166985daafa29914dd409c"
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
