class Nanomsgxx < Formula
  desc "Nanomsg binding for C++11"
  homepage "https://achille-roussel.github.io/nanomsgxx/doc/nanomsgxx.7.html"
  url "https://github.com/achille-roussel/nanomsgxx/archive/refs/tags/0.2.tar.gz"
  sha256 "116ad531b512d60ea75ef21f55fd9d31c00b172775548958e5e7d4edaeeedbaa"
  license "MIT"
  revision 4

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "01912c3e6e92067cd9b234006271a00b235a3a91f15f5e1948aa7add4830b6b8"
    sha256 cellar: :any, arm64_tahoe:       "8517e8dc49794d794f4a1fd2473039e6bb1d0e90065bb53123ddc4bcf652fbe2"
    sha256 cellar: :any, arm64_sequoia:     "f6a068a937d9f6eb8f01697600b851a6e4a938349037d759f52b2f14133f7529"
    sha256 cellar: :any, arm64_linux:       "f409ca07a6bbec34e33aa96c8306594731eedfb9aefce36fa7c863d9a222137e"
    sha256 cellar: :any, x86_64_linux:      "8b59ee63415ff903446f997a7a8373cfc1803aa370e323cfdf68dd20fc4dd273"
  end

  depends_on "pkgconf" => :build
  depends_on "nanomsg"

  uses_from_macos "python" => :build

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
    type :backport
    resolves "https://github.com/achille-roussel/nanomsgxx/pull/9"
  end

  # Add support for newer version of waf
  patch do
    url "https://github.com/achille-roussel/nanomsgxx/commit/08c6d8882e40d0279e58325d641a7abead51ca07.patch?full_index=1"
    sha256 "fa27cad45e6216dfcf8a26125c0ff9db65e315653c16366a82e5b39d6e4de415"
    type :unofficial
    resolves "https://github.com/achille-roussel/nanomsgxx/pull/13"
  end

  def install
    resource("waf").stage buildpath
    chmod 0755, "waf"

    args = %W[
      --static
      --shared
      --prefix=#{prefix}
      --libdir=#{lib}
    ]

    system "python3", "./waf", "configure", *args
    system "python3", "./waf", "build"
    system "python3", "./waf", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
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
    CPP

    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lnnxx"

    assert_equal "Hello Nanomsgxx!\n", shell_output("#{testpath}/a.out")
  end
end
