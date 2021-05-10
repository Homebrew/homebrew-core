class Nanomsgxx < Formula
  desc "Nanomsg binding for C++11"
  homepage "https://achille-roussel.github.io/nanomsgxx/doc/nanomsgxx.7.html"
  url "https://github.com/achille-roussel/nanomsgxx/archive/0.2.tar.gz"
  sha256 "116ad531b512d60ea75ef21f55fd9d31c00b172775548958e5e7d4edaeeedbaa"
  license "MIT"
  revision 2

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_big_sur: "e60ddc9b8115ed727673f40c00a2c6fd25b6b60337786d376d4f348b99095be9"
    sha256 cellar: :any, big_sur:       "a6eba6de285e05c979bc694c6aec53b51ccb764bd5578af5fe484fa1f198efde"
    sha256 cellar: :any, catalina:      "3c094b3df14d706b6824d0f0e4ec90e2d6aace65e8f7fe484b38fc51b2fe298f"
    sha256 cellar: :any, mojave:        "b4e9a2d42d4307ef122c71288afed6662f0db91be922c73324abe6e5a2b08735"
    sha256 cellar: :any, high_sierra:   "c48e210289abc4d384fc1139d4565616bb04fbced6f6fae9a6817f2c710ba118"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "nanomsg"

  # Add python3 support
  #
  # This patch mimics changes from https://github.com/achille-roussel/nanomsgxx/pull/26
  # but can't be applied as a formula patch since it contains GIT binary patch
  #
  # Remove this in next release
  resource "waf" do
    url "https://raw.githubusercontent.com/achille-roussel/nanomsgxx/4426567809a79352f65bbd2d69488df237442d33/waf"
    sha256 "0a09ad26a2cfc69fa26ab871cb558165b60374b5a653ff556a0c6aca63a00df1"
  end

  patch do
    url "https://github.com/achille-roussel/nanomsgxx/commit/f5733e2e9347bae0d4d9e657ca0cf8010a9dd6d7.patch?full_index=1"
    sha256 "e6e05e5dd85b8131c936750b554a0a874206fed11b96413b05ee3f33a8a2d90f"
  end

  # Add support for newer version of waf
  patch do
    url "https://github.com/achille-roussel/nanomsgxx/commit/08c6d8882e40d0279e58325d641a7abead51ca07.patch?full_index=1"
    sha256 "fa27cad45e6216dfcf8a26125c0ff9db65e315653c16366a82e5b39d6e4de415"
  end

  def install
    resource("waf").stage buildpath
    chmod 0755, "waf"

    args = %W[
      --static
      --shared
      --prefix=#{prefix}
    ]

    system "python3", "./waf", "configure", *args
    system "python3", "./waf", "build"
    system "python3", "./waf", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <nnxx/message.h>
      #include <nnxx/pair.h>
      #include <nnxx/socket.h>

      int main() {
        nnxx::socket s1 { nnxx::SP, nnxx::PAIR };
        nnxx::socket s2 { nnxx::SP, nnxx::PAIR };
        const char *addr = "inproc://example";

        s1.bind(addr);
        s2.connect(addr);

        s1.send("Hello Nanomsgxx!");

        nnxx::message msg = s2.recv();
        std::cout << msg << std::endl;
        return 0;
      }
    EOS

    system ENV.cxx, "-std=c++11", "-L#{lib}", "-lnnxx", "test.cpp"

    assert_equal "Hello Nanomsgxx!\n", shell_output("#{testpath}/a.out")
  end
end
