class Giza < Formula
  desc "Scientific plotting library for C/Fortran built on cairo"
  homepage "https://danieljprice.github.io/giza/"
  url "https://downloads.sourceforge.net/project/giza/v1.1.0/giza-1.1.0.tar.gz"
  sha256 "69f6b8187574eeb66ec3c1edadf247352b0ffebc6fc6ffbb050bafd324d3e300"
  license "GPL-2.0-or-later"

  bottle do
    cellar :any
    sha256 "7a485d9f66a4b57eadf001fe38219c52b95ddd097830a02cdc3356b2e435765d" => :big_sur
    sha256 "4f8cdbde732c7a01b43daac9e9970911458af323b9ecf82e8f64264e1d04464c" => :arm64_big_sur
    sha256 "4651e890ce15036cb2e8862a5c72d56201be4cfc345f7f66d95aa3fd452b6615" => :catalina
    sha256 "3bfd5ff70ee646773ac6d799c3bd5865a9ab689833ca1f484a6402fa9443b105" => :mojave
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
