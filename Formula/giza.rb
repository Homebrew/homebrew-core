class Giza < Formula
  desc "Scientific plotting library for C/Fortran built on cairo"
  homepage "https://danieljprice.github.io/giza/"
  url "https://github.com/danieljprice/giza/archive/v1.2.0.tar.gz"
  sha256 "40f0c4744852b9d054124b173357c84147f80194a10ada08603766cf497125cb"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/danieljprice/giza.git"

  bottle do
    sha256               arm64_big_sur: "b7d206182dc5e0e0d55ca44cef2853da3450139e709e681e60a74227577a57d7"
    sha256 cellar: :any, big_sur:       "91ada9adb0cd434916d29fe857d3bdc13510b6cc0477a1d2b4d26484e5c213f1"
    sha256 cellar: :any, catalina:      "1eac9b01739dc3c8575aec73bd10a3324f8e61a8f97441cce50d879ab2cfe42b"
    sha256 cellar: :any, mojave:        "64f9257f31d1a62163609fcb874387193cc32f349c81b8e0f2359dee8a118a2c"
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
