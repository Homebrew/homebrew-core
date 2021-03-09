class Giza < Formula
  desc "Scientific plotting library for C/Fortran built on cairo"
  homepage "https://danieljprice.github.io/giza/"
  url "https://github.com/danieljprice/giza/archive/v1.2.0.tar.gz"
  sha256 "40f0c4744852b9d054124b173357c84147f80194a10ada08603766cf497125cb"
  license "GPL-2.0-or-later"
  head "https://github.com/danieljprice/giza.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "481144448b46e0e91687e0204912fed0001e446af9d17398fd5a1d79107c4211"
    sha256 cellar: :any, big_sur:       "92f73283c143734b3d418bdd45fb44b15ddd90ed6f5a9d0b54205f8a9ac0f1eb"
    sha256 cellar: :any, catalina:      "52c1a11f3837ee60692665755b4235fc78fa4503feac78e41166b59b62e1180f"
    sha256 cellar: :any, mojave:        "be4dc2e327046559840cc4d65b9f98aa4b780d642ca7a6d1ebbb1c472ee41249"
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
