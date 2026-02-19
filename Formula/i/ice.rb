class Ice < Formula
  desc "Comprehensive RPC framework"
  homepage "https://zeroc.com"
  url "https://github.com/zeroc-ice/ice/archive/refs/tags/v3.8.0.tar.gz"
  sha256 "ec03e18b1bb0e83547744f3d0d0b73b60e5b497bed10de6f933b54525802a3cb"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e0571d68dbdc9d073f52bcc8dde10ba8273cea43d6fd245b5929905cbf1a18f9"
    sha256 cellar: :any,                 arm64_sequoia: "5b59424b75dd9c915c2ae6f7ca309fb24a7d86daa0f8016ba86bcff4ef9cecd7"
    sha256 cellar: :any,                 arm64_sonoma:  "8d1f90a90863feb399931937ae20030dbab7b59370f985f7af98d0be12025429"
    sha256 cellar: :any,                 sonoma:        "606185d3a72b5f41517abd9820a5d9aecde6e2f29ba40cbcdf57e72b054fffa9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1f791eec7808a1d4a4eaebe3d8f9c751d1a8f462e0eb220f563762b617f08f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb9505307af9af938603a49a7078ef093337a7a8b760a29a25d541ebeab26e96"
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
      "MCPP_HOME=#{Formula["mcpp"].opt_prefix}",
      "LMDB_HOME=#{Formula["lmdb"].opt_prefix}",
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
