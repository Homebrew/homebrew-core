class Nanomsgxx < Formula
  desc "Nanomsg binding for C++11"
  homepage "https://achille-roussel.github.io/nanomsgxx/doc/nanomsgxx.7.html"
  url "https://github.com/achille-roussel/nanomsgxx/archive/0.2.tar.gz"
  sha256 "116ad531b512d60ea75ef21f55fd9d31c00b172775548958e5e7d4edaeeedbaa"
  license "MIT"
  revision 3

  bottle do
    rebuild 4
    sha256 cellar: :any,                 arm64_monterey: "d3c9bed1411f07744e9a8ec93f6bf2ddfefc01d52b0a848a71897534c94a9289"
    sha256 cellar: :any,                 arm64_big_sur:  "f306a0110e35f1e08fbe241993df9c241bb34b02d9f09baeaa3ec3399763e57e"
    sha256 cellar: :any,                 monterey:       "0d213072aa619131d346310c7f2f02e0d41c51cf52bb53c4b7f8743e1b1d26e7"
    sha256 cellar: :any,                 big_sur:        "08e27ade48b0c93ca759e7fcdbe0f8270ba7300ad45d14606eb6a959be53f0dd"
    sha256 cellar: :any,                 catalina:       "6827a58b75548b6146396dff941aa8d891ef739f6077d33f005b5e2161263007"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4e4084e9d12379b31121f81db0e992f5cc198693cf5d6a9110e949128b94d65"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
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

    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lnnxx"

    assert_equal "Hello Nanomsgxx!\n", shell_output("#{testpath}/a.out")
  end
end
