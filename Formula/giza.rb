class Giza < Formula
  desc "Scientific plotting library for C/Fortran built on cairo"
  homepage "https://danieljprice.github.io/giza/"
  url "https://github.com/danieljprice/giza/archive/v1.3.1.tar.gz"
  sha256 "b6bae5ba44a8fd921c3430e61b1ce5c6b7febfe7fa835a7c8724d19089bba0b9"
  license "GPL-2.0-or-later"
  head "https://github.com/danieljprice/giza.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7edc9b2eab4a57f5c0dce35bd4959c160652cd5bd644ac343017f6140933f0e3"
    sha256 cellar: :any,                 arm64_big_sur:  "b11820712e2b6a7bf7e78a382c5f3f1384b94d0938b09d871261d385d2c95667"
    sha256 cellar: :any,                 monterey:       "10f658a41ed0ea24c45c9aeaa8886b43a7350da6a27d02a686e9c8bc62564f66"
    sha256 cellar: :any,                 big_sur:        "b4c5f4ca03b8521052bfd7a3b9551aec635341e5a1d72e2f02baaeefa5218eed"
    sha256 cellar: :any,                 catalina:       "46b4572baadcc66dee8dd99ebc8d1159f9898132dc9b8ce71879dc7ca3d62a6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c3d05870b9d06ea5f8ea1bbdeb0434ac6daf6b3742b7422bbb440ce364c1c30"
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

    testfiles = Dir.children("#{testpath}/C")

    testfiles.first(5).each do |file|
      system ENV.cc, "C/#{file}", *flags
    end
  end
end
