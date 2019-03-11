class Nanomsgxx < Formula
  desc "Nanomsg binding for C++11"
  homepage "https://achille-roussel.github.io/nanomsgxx/doc/nanomsgxx.7.html"
  url "https://github.com/achille-roussel/nanomsgxx/archive/0.2.tar.gz"
  sha256 "116ad531b512d60ea75ef21f55fd9d31c00b172775548958e5e7d4edaeeedbaa"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "ece20152a6ddcd9bd5a931b8c190de6c998da9ad3bacb195ae69fc3671767d50" => :mojave
    sha256 "dd6e547bd44055f348857c15843c16965b4dd03ea82713069cbb5df9836f1009" => :high_sierra
    sha256 "25067fb5373110f213ef8fb8e662e274db47c84e6058777e646489e1257d457d" => :sierra
  end

  depends_on "pkg-config" => :build
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
