class Ice < Formula
  desc "Comprehensive RPC framework"
  homepage "https://zeroc.com"
  url "https://github.com/zeroc-ice/ice/archive/refs/tags/v3.8.3.tar.gz"
  sha256 "62240ed349317f72269ebf1b26e8b3629a09ad9a915031e942e83f75e9fb6971"
  # See https://github.com/zeroc-ice/ice/blob/main/ICE_LICENSE for a special
  # exception to combine Ice with the OpenSSL library and Apache-2.0 libraries
  license "GPL-2.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0eeaff7d05edcda23dfc69a6ca0cdb6a579fa186d428bfbb5516a1af61ac3863"
    sha256 cellar: :any, arm64_tahoe:       "e3a93f5d3f46074fe78b962ee60cb01750016120a25894a2699a2508de0fecc2"
    sha256 cellar: :any, arm64_sequoia:     "a3af5ff17d867aadfd1f4938daee712f1a352158f5405edd4b2b7e07740f4ead"
    sha256 cellar: :any, arm64_sonoma:      "1a5688b1352d43fd82d5e5750eb76a47e364753084e198336de3f1dde53c16ea"
    sha256 cellar: :any, arm64_linux:       "89ba380f6d5b9e05f011c61b99558e71f2649e6a8ef039f6e4c0b95efbfdd113"
    sha256 cellar: :any, x86_64_linux:      "b5f4194d6114e3264fed48972c2c4334ac4e20a1ec6265e84fd7fd5be91daedf"
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
