class Giza < Formula
  desc "Scientific plotting library for C/Fortran built on cairo"
  homepage "https://danieljprice.github.io/giza/"
  url "https://github.com/danieljprice/giza/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "d45f1f930b4e4a3c77e0b110b97b732c290d169bf9ae0c3fc7dcd2895c1b3afe"
  license "LGPL-3.0-only"
  head "https://github.com/danieljprice/giza.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "357de5d9ec314c012a17c428792abc415a69b41c79a3a70217306b99b7b0553f"
    sha256 cellar: :any,                 arm64_sequoia: "d5cc5b8ea3baf6cb3405ec37acb4ef91623456492cd0222787bf9461272d4e80"
    sha256 cellar: :any,                 arm64_sonoma:  "77d5fc21407f015635c46f41f0bdcb5aabbb320c967f30d3eafe639f9b1d9b71"
    sha256 cellar: :any,                 arm64_ventura: "bdd8d667ec2cd0d4553748b79f8e77f41a4740f7bae0e584e0981274f3def56d"
    sha256 cellar: :any,                 sonoma:        "b4eed7ab19e5b3d979c9e3329d764ad7059b4d65b6ae3fcf75ce2a6159cf2f7c"
    sha256 cellar: :any,                 ventura:       "0e7d7bed8f2db32709a52169fb98bd47c57c361138364e4dbc7a4a41604273e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d695e84283aa5d04c6565ef04815a27020c0011ffdf3f6a58e86565a08aef9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce3e71bc56a0ebaaf18f8649b0b92eec8e51149ebc6a2ce5bdd9ffce0e5c6cdf"
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
