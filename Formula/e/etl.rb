class Etl < Formula
  desc "Extensible Template Library"
  homepage "https://synfig.org"
  url "https://github.com/synfig/synfig/releases/download/v1.5.5/ETL-1.5.5.tar.gz"
  sha256 "570c898f1c976fac3026866d718ea3f48f8bce1b232ed8cbedc65921c4e3cc25"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0a4090f4ab50fbb307622bff66ee04cc9150a73eb1213b4130d923153a755f66"
  end

  depends_on "pkgconf" => :build
  depends_on "glibmm@2.66"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <ETL/etl_profile.h>

      int main()
      {
        std::cout << "ETL Name: " << ETL_NAME << std::endl;
        std::cout << "ETL Version: " << ETL_VERSION << std::endl;
        return 0;
      }
    CPP
    flags = %W[
      -I#{include}/ETL
      -lpthread
    ]
    system ENV.cxx, "test.cpp", "-o", "test", *flags
    output = shell_output("./test")
    assert_match "ETL", output
    assert_match version.to_s, output
  end
end
