class Giza < Formula
  desc "Scientific plotting library for C/Fortran built on cairo"
  homepage "https://danieljprice.github.io/giza/"
  url "https://github.com/danieljprice/giza/archive/v1.2.1.tar.gz"
  sha256 "8bf02828dc3e25a51ca1ac9229df41e86ba2a779af49d06c1a3077ecc4721821"
  license "GPL-2.0-or-later"
  head "https://github.com/danieljprice/giza.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f90bb6e21ea8fc3919706b4584995623f763b11f1961ea474e10f31b0c3fba72"
    sha256 cellar: :any, monterey:      "215259692a128badd9e2f5ccecc743bd8f0ae1c727196f35a891cac1837023e1"
    sha256 cellar: :any, big_sur:       "8ef54fe8593cb6dbae489f634dbe6fddb7fbfa495af95c3cea6f8bc52ac4ae5c"
    sha256 cellar: :any, catalina:      "81bd1caa8dbc15f4f9865cd9de5956d2371c500febf10289b2fad40a60d333de"
    sha256 cellar: :any, mojave:        "05008343af562f24851230c306ce451041465726e3d45f20da94fcbd61424e8b"
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
      -L#{lib}
      -lgiza
    ]

    testfiles = Dir.children("#{testpath}/C")

    testfiles.first(5).each do |file|
      system ENV.cc, "C/#{file}", *flags
    end
  end
end
