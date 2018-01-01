class Nanomsgxx < Formula
  desc "Nanomsg binding for C++11"
  homepage "https://achille-roussel.github.io/nanomsgxx/doc/nanomsgxx.7.html"
  url "https://github.com/achille-roussel/nanomsgxx/archive/0.2.tar.gz"
  sha256 "116ad531b512d60ea75ef21f55fd9d31c00b172775548958e5e7d4edaeeedbaa"
  revision 1

  bottle do
    cellar :any
    sha256 "b35ef1c194aea9a8b1c59495dadec535d748ad21003843caf1d520743d4e6a88" => :high_sierra
    sha256 "31944634bba1c194586658fd0d7ab9bc5c2564f334a9fbbea3d1af57dc43ef55" => :sierra
    sha256 "e70ca4633486bd83259989bf62041e5e140401fbecc7bb4e855375229b016312" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "python" => :build if MacOS.version <= :snow_leopard

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
