class Ginac < Formula
  desc "Not a Computer algebra system"
  homepage "https://www.ginac.de/"
  url "https://www.ginac.de/ginac-1.8.9.tar.bz2"
  sha256 "6cfd46cf4e373690e12d16b772d7aed0f5c433da8c7ecd2477f2e736483bb439"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.ginac.de/Download.html"
    regex(/href=.*?ginac[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "883d484b1214d73fb0a9d1a3abb1272c416710e13a03c9e033a349a430eba558"
    sha256 cellar: :any,                 arm64_sonoma:  "c83c904f36bc6f67c50be2f63c97e222612c38b7cdb75bc6165932fb0d02ee8f"
    sha256 cellar: :any,                 arm64_ventura: "91b38f0301a06bfd7da8d4156d01df8619f2fe0607a679b2bb9353ff7fcbfe46"
    sha256 cellar: :any,                 sonoma:        "9a8246939afc6c0715768e4059eb043c6b30de52b9b14b88000d497593485888"
    sha256 cellar: :any,                 ventura:       "8daafe6097f1dddebf76c3c5c16517ef2f4a47a605b265bb6c55cb832e5d7e47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "630df100084e0ebcf28141863b6735bad56ecf8804bd1fba8318c489e2287601"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a8e6089bd699f62ec5f3350eca6856c51be620187f8725198c8ebe06b1bdbe0"
  end

  depends_on "pkgconf" => :build
  depends_on "cln"
  depends_on "python@3.13"
  depends_on "readline"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <ginac/ginac.h>
      using namespace std;
      using namespace GiNaC;

      int main() {
        symbol x("x"), y("y");
        ex poly;

        for (int i=0; i<3; ++i) {
          poly += factorial(i+16)*pow(x,i)*pow(y,2-i);
        }

        cout << poly << endl;
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test",
                    "-L#{lib}", "-L#{Formula["cln"].lib}", "-lcln", "-lginac"
    system "./test"
  end
end
