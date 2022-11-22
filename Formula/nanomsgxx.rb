class Nanomsgxx < Formula
  desc "Nanomsg binding for C++11"
  homepage "https://achille-roussel.github.io/nanomsgxx/doc/nanomsgxx.7.html"
  url "https://github.com/achille-roussel/nanomsgxx/archive/0.2.tar.gz"
  sha256 "116ad531b512d60ea75ef21f55fd9d31c00b172775548958e5e7d4edaeeedbaa"
  license "MIT"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "edb680fdffb9c416a4d16175673b8a94f1ad2c84a668ff3814f749a811f98889"
    sha256 cellar: :any,                 arm64_monterey: "8436ab0a7b9ed4472dfa37e576b2003510ca115e1ae686b2352d3bb00c351d92"
    sha256 cellar: :any,                 arm64_big_sur:  "722cb87d23c8dc14f3be995f3a83d3c8da43a2b76ebf621d57c27d63ce7c2598"
    sha256 cellar: :any,                 ventura:        "b3f6da0864f1363f4841affd17e32669c718e39865e5678af6fc968799e0fb96"
    sha256 cellar: :any,                 monterey:       "2cfef95f0fc27d9d297a50191ae3d8e1d69b9a8f80ff3f34bc6bb90a9626a41f"
    sha256 cellar: :any,                 big_sur:        "6509c8160cbe5dba38a77d3adc1f1d5d515feff427bad6441992dc40cb5b4d1a"
    sha256 cellar: :any,                 catalina:       "0c377d26b223a21b48d90920818baf7b241ebadfac8c60a3420e0c3054df7401"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed20e2617835e53e1ee41927a5066275c7b7a6058de093932be16bb89bf23cd4"
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

    python3 = "python3.10"
    system python3, "./waf", "configure", *args
    system python3, "./waf", "build"
    system python3, "./waf", "install"
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
