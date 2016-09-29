class Ice < Formula
  desc "Comprehensive RPC framework"
  homepage "https://zeroc.com"
  url "https://github.com/zeroc-ice/ice/archive/v3.6.2.tar.gz"
  sha256 "5e9305a5eb6081c8f128d63a5546158594e9f115174fc91208f645dbe2fc02fe"

  bottle do
    sha256 "ef487cbf3e812e9c3f1fefd704ced9c946e3c64cfdb252e29b8d406dafb54336" => :sierra
    sha256 "0fdf8a52db7dc217a9558651593d6bfc2453a040468c8fe81770d91ba9dbf5cf" => :el_capitan
    sha256 "3125842bc055bc4bc6121c93823a9b064936b57c4ae3a9f6eed163772d5786c1" => :yosemite
    sha256 "f8ae8569e2aace9f55e3f631eacc3913cb8b300042c22bab66c2e72fd5b16651" => :mavericks
  end

  option "with-java", "Build Ice for Java and the IceGrid Admin app"

  depends_on "mcpp"
  depends_on :java => ["1.7+", :optional]
  depends_on :macos => :mavericks

  resource "berkeley-db" do
    url "https://zeroc.com/download/homebrew/db-5.3.28.NC.brew.tar.gz"
    sha256 "8ac3014578ff9c80a823a7a8464a377281db0e12f7831f72cef1fd36cd506b94"
  end

  def install
    resource("berkeley-db").stage do
      # BerkeleyDB dislikes parallel builds
      ENV.deparallelize
      args = %W[
        --disable-debug
        --prefix=#{libexec}
        --mandir=#{libexec}/man
        --enable-cxx
      ]

      if build.with? "java"
        args << "--enable-java"

        # @externl from ZeroC submitted this patch to Oracle through an internal ticket system
        inreplace "dist/Makefile.in", "@JAVACFLAGS@", "@JAVACFLAGS@ -source 1.7 -target 1.7"
      end

      # BerkeleyDB requires you to build everything from the build_unix subdirectory
      cd "build_unix" do
        system "../dist/configure", *args
        system "make", "install"
      end
    end

    inreplace "cpp/src/slice2js/Makefile", /install:/, "dontinstall:"

    # Unset ICE_HOME as it interferes with the build
    ENV.delete("ICE_HOME")
    ENV.delete("USE_BIN_DIST")
    ENV.delete("CPPFLAGS")
    ENV.O2

    args = %W[
      prefix=#{prefix}
      USR_DIR_INSTALL=yes
      OPTIMIZE=yes
      DB_HOME=#{libexec}
      MCPP_HOME=#{Formula["mcpp"].opt_prefix}
    ]

    cd "cpp" do
      system "make", "install", *args
    end

    cd "objective-c" do
      system "make", "install", *args
    end

    if build.with? "java"
      cd "java" do
        system "make", "install", *args
      end
    end

    cd "php" do
      args << "install_phpdir=#{share}/php"
      args << "install_libdir=#{lib}/php/extensions"
      system "make", "install", *args
    end
  end

  test do
    (testpath/"Hello.ice").write <<-EOS.undent
      module Test {
        interface Hello {
          void sayHello();
        };
      };
    EOS
    (testpath/"Test.cpp").write <<-EOS.undent
      #include <Ice/Ice.h>
      #include <Hello.h>

      class HelloI : public Test::Hello {
      public:
        virtual void sayHello(const Ice::Current&) {}
      };

      int main(int argc, char* argv[]) {
        Ice::CommunicatorPtr communicator;
        communicator = Ice::initialize(argc, argv);
        Ice::ObjectAdapterPtr adapter =
            communicator->createObjectAdapterWithEndpoints("Hello", "default -h localhost -p 10000");
        adapter->add(new HelloI, communicator->stringToIdentity("hello"));
        adapter->activate();
        communicator->destroy();
        return 0;
      }
    EOS
    system "#{bin}/slice2cpp", "Hello.ice"
    system "xcrun", "clang++", "-c", "-I#{include}", "-I.", "Hello.cpp"
    system "xcrun", "clang++", "-c", "-I#{include}", "-I.", "Test.cpp"
    system "xcrun", "clang++", "-L#{lib}", "-o", "test", "Test.o", "Hello.o", "-lIce", "-lIceUtil"
    system "./test", "--Ice.InitPlugins=0"
  end
end
