class Giza < Formula
  desc "Scientific plotting library for C/Fortran built on cairo"
  homepage "https://danieljprice.github.io/giza/"
  url "https://github.com/danieljprice/giza/archive/v1.3.2.tar.gz"
  sha256 "080b9d20551bc6c6a779b1148830d0e89314c9a78c5a934f9ec8f02e8e541372"
  license "GPL-2.0-or-later"
  head "https://github.com/danieljprice/giza.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "44a56e84ca807f58adaf6eaa3468a0d5def6e53baa7ef5a93271ed810cc80ff0"
    sha256 cellar: :any,                 arm64_big_sur:  "3e792b9f7c3182e6c267abab3dcfa5a388694525d8b5acbf2cb74d693ab6d7ee"
    sha256 cellar: :any,                 monterey:       "150ab9f0eaaf53728c0564019ab871834aed555ad242144a5f0305596c4678e5"
    sha256 cellar: :any,                 big_sur:        "ac9a2190b49adb41fbb79fee29283581826b484f7609edaac604712420a9e585"
    sha256 cellar: :any,                 catalina:       "ff67af5b932fb77e023dab9934f4b45059bf218a985d14d9faff9e2938e38e7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af77879b955403d702200385e26cb3689f7aaf0d4cdc7007575637524c17bc26"
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
