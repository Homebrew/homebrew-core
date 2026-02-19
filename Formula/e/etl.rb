class Etl < Formula
  desc "Extensible Template Library"
  homepage "https://synfig.org"
  url "https://github.com/synfig/synfig/releases/download/v1.5.4/ETL-1.5.4.tar.gz"
  sha256 "d9f9d162fa8a8f61ab1b9983b69180fb0e39573535dfce3b1cbb912a6ffe2d51"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b9be50e653da648b1206894ca4374aa8e0209c8422a307e019fc37152f819df8"
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
