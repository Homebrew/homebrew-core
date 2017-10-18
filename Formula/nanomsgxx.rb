class Nanomsgxx < Formula
  desc "Nanomsg binding for C++11"
  homepage "https://achille-roussel.github.io/nanomsgxx/doc/nanomsgxx.7.html"
  url "https://github.com/achille-roussel/nanomsgxx/archive/0.2.tar.gz"
  sha256 "116ad531b512d60ea75ef21f55fd9d31c00b172775548958e5e7d4edaeeedbaa"
  revision 1

  bottle do
    cellar :any
    sha256 "2b4216a092883e6459691d19070eecb323f65bdf3be5ace59c58b54324a419b5" => :high_sierra
    sha256 "d61b7a3a91b7568325a5b94382ac978a60fb4c190ef2627db9d3a563cc3cbc15" => :sierra
    sha256 "13abe2463ffcf219b5bcc3ae0ef48e0d99e2d9810ebb9e28c2344e9f4ef4cd6a" => :el_capitan
    sha256 "5d1ef8eed698ca5e10d28fa5609033f546f8d831130b58d17c3369098482230c" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on :python => :build if MacOS.version <= :snow_leopard

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
    (testpath/"test.cpp").write <<-EOS.undent
      #include <iostream>
      int main(int argc, char **argv) {
        std::cout << "Hello Nanomsgxx!" << std::endl;
      }
    EOS

    system ENV.cxx, "-std=c++11", "-L#{lib}", "-lnnxx", "test.cpp"

    assert_equal "Hello Nanomsgxx!\n", shell_output("#{testpath}/a.out")
  end
end
