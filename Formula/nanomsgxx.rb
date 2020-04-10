class Nanomsgxx < Formula
  desc "Nanomsg binding for C++11"
  homepage "https://achille-roussel.github.io/nanomsgxx/doc/nanomsgxx.7.html"
  url "https://github.com/achille-roussel/nanomsgxx/archive/0.2.tar.gz"
  sha256 "116ad531b512d60ea75ef21f55fd9d31c00b172775548958e5e7d4edaeeedbaa"
  revision 2

  bottle do
    cellar :any
    rebuild 2
    sha256 "3c094b3df14d706b6824d0f0e4ec90e2d6aace65e8f7fe484b38fc51b2fe298f" => :catalina
    sha256 "b4e9a2d42d4307ef122c71288afed6662f0db91be922c73324abe6e5a2b08735" => :mojave
    sha256 "c48e210289abc4d384fc1139d4565616bb04fbced6f6fae9a6817f2c710ba118" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on :macos # Due to Python 2
  depends_on "nanomsg"

  def install
    args = %W[
      --static
      --shared
      --prefix=#{prefix}
    ]

    system "python", "./waf", "configure", *args
    system "python", "./waf", "build"
    system "python", "./waf", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      int main(int argc, char **argv) {
        std::cout << "Hello Nanomsgxx!" << std::endl;
      }
    EOS

    system ENV.cxx, "-std=c++11", "-L#{lib}", "-lnnxx", "test.cpp"

    assert_equal "Hello Nanomsgxx!\n", shell_output("#{testpath}/a.out")
  end
end
