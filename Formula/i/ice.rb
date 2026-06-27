class Ice < Formula
  desc "Comprehensive RPC framework"
  homepage "https://zeroc.com"
  url "https://github.com/zeroc-ice/ice/archive/refs/tags/v3.8.2.tar.gz"
  sha256 "d350ebbcdd7971fafccebfdf1e99db139dc6d121f5a5dcdc4036256206735078"
  # See https://github.com/zeroc-ice/ice/blob/main/ICE_LICENSE for a special
  # exception to combine Ice with the OpenSSL library and Apache-2.0 libraries
  license "GPL-2.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e5531b89902400d1d4c92be7fba9f2f23d698cf1d294c7df5acbccd4560973d4"
    sha256 cellar: :any, arm64_sequoia: "0e908f79827033d24305469f2e446aaee91cd7cec82f4e5340a49de087f6ee5c"
    sha256 cellar: :any, arm64_sonoma:  "554344817bb31eba6bf45a8ca40f545612eb22bbabdbe2dd86bd4f9302125420"
    sha256 cellar: :any, sonoma:        "0f68d166703bf0a112710432b7f366334d4d781a8ebc0dffb19a3c2871246e1c"
    sha256 cellar: :any, arm64_linux:   "89bb7e85d0ea9aaca429730a46207589bfbd9dfc8f749c9226646a446eaa8d75"
    sha256 cellar: :any, x86_64_linux:  "dd11f21ce440a415e2652185e6cea0e8e8dde2eba6d365da127a70289f1de9c3"
  end

  depends_on "lmdb"
  depends_on "mcpp"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "libedit"
  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    if DevelopmentTools.clang_build_version < 1700
      inreplace "config/Make.rules.Darwin", "-Wl,-max_default_common_align,0x4000", ""
    end

    args = [
      "prefix=#{prefix}",
      "V=1",
      "USR_DIR_INSTALL=yes", # ensure slice and man files are installed to share
      "MCPP_HOME=#{formula_opt_prefix("mcpp")}",
      "LMDB_HOME=#{formula_opt_prefix("lmdb")}",
      "CONFIGS=all",
      "PLATFORMS=all",
      "LANGUAGES=cpp",
    ]
    system "make", "install", *args
  end

  test do
    (testpath/"Hello.ice").write <<~EOS
      module Test
      {
          interface Hello
          {
              void sayHello();
          }
      }
    EOS

    port = free_port

    (testpath/"Test.cpp").write <<~CPP
      #include "Hello.h"
      #include <Ice/Ice.h>

      class HelloI : public Test::Hello
      {
      public:
          void sayHello(const Ice::Current&) override {}
      };

      int main(int argc, char* argv[])
      {
        Ice::CommunicatorHolder ich(argc, argv);
        auto adapter = ich->createObjectAdapterWithEndpoints("Hello", "default -h 127.0.0.1 -p #{port}");
        adapter->add(std::make_shared<HelloI>(), Ice::stringToIdentity("hello"));
        adapter->activate();
        return 0;
      }
    CPP

    system bin/"slice2cpp", "Hello.ice"
    system ENV.cxx, "-std=c++20", "-c", "-I#{include}", "Hello.cpp"
    system ENV.cxx, "-std=c++20", "-c", "-I#{include}", "Test.cpp"
    system ENV.cxx, "-L#{lib}", "-o", "test", "Test.o", "Hello.o", "-lIce", "-lpthread"
    system "./test"
  end
end
