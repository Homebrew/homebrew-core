class Ice < Formula
  desc "Comprehensive RPC framework"
  homepage "https://zeroc.com"
  url "https://github.com/zeroc-ice/ice/archive/refs/tags/v3.8.1.tar.gz"
  sha256 "87aa0381f2347715467686547bccf253fa208948bf2a462584872d2d0f8b1720"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e73d5cc15f629eb8381d7dbbb6dc196f67234bba957ca78bc6f7884e925eb763"
    sha256 cellar: :any,                 arm64_sequoia: "fa69325f0ba3ad72906a3f86e40cb52908b6f89aea97c68424256ac3d537db81"
    sha256 cellar: :any,                 arm64_sonoma:  "31fffc8a580481083e88786d2996e47fadf8ddde7478e1018db0aec5d470605d"
    sha256 cellar: :any,                 sonoma:        "32f6816651a201d6c364b04745e2df920777bbaac0d3d5599e1edf0477a2097c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9586db5fca4281079514d7b00c50f9c40204d789d81abd854d99274e2261c595"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8440c54d6797e2ccfdc0bd26dc0b64d6e3563b976a8d19936dbe4e2dd6280a8b"
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
