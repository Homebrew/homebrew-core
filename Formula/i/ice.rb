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
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "8e073f0de8b5851202081052d662844ac4fff71b610af8a666241bab1d7e6d22"
    sha256 cellar: :any, arm64_tahoe:       "e59ea26dbcd53be26c2cc49f5025c66e9ce43da5ee49306a2dd1c721ab87a64f"
    sha256 cellar: :any, arm64_sequoia:     "5d405e0f2fac608487efea6d942b94c509fd89797c5cb115a5dc8eb2a0c82eed"
    sha256 cellar: :any, arm64_linux:       "2dc3df4164dd9eb9242483c04b17fd34bb66d198af413f8fc56e25ce99e6f41d"
    sha256 cellar: :any, x86_64_linux:      "065f81ee9430824803fa10f2dec841717271e22473b3b691fd521ccf6a67dfd2"
  end

  depends_on "lmdb"
  depends_on "mcpp"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "libedit"
  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "openssl@4"
  end

  allow_network_access! :test

  def install
    if DevelopmentTools.clang_build_version < 1700
      inreplace "config/Make.rules.Darwin", "-Wl,-max_default_common_align,0x4000", ""
    end
    # Work around some const correctness when using OpenSSL 4
    ENV.append_to_cflags "-fpermissive" if OS.linux?

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
    system ENV.cxx, "-std=c++20", "-c", "-I#{include}", "-I#{formula_opt_include("openssl@4")}", "Hello.cpp"
    system ENV.cxx, "-std=c++20", "-c", "-I#{include}", "-I#{formula_opt_include("openssl@4")}", "Test.cpp"
    system ENV.cxx, "-L#{lib}", "-o", "test", "Test.o", "Hello.o", "-lIce", "-lpthread"
    system "./test"
  end
end
