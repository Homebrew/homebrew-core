class Giza < Formula
  desc "Scientific plotting library for C/Fortran built on cairo"
  homepage "https://danieljprice.github.io/giza/"
  url "https://downloads.sourceforge.net/project/giza/v1.1.0/giza-1.1.0.tar.gz"
  sha256 "69f6b8187574eeb66ec3c1edadf247352b0ffebc6fc6ffbb050bafd324d3e300"
  license "GPL-2.0-or-later"

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

    on_macos do
      ENV["CC"] = "#{Formula["gcc"].bin}/gcc-10"
    end

    flags = %W[
      -I#{include}
      -L#{lib}
      -lgiza
    ]

    testfiles = Dir.children("#{testpath}/C")

    testfiles.first(5).each do |file|
      system ENV.cc, "C/#{file}", *flags
    end
  end
end
