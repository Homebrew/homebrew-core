class Ice < Formula
  desc "Comprehensive RPC framework"
  homepage "https://zeroc.com"
  url "https://github.com/zeroc-ice/ice/archive/v3.7.0.tar.gz"
  sha256 "a6bd6faffb29e308ef8f977e27a526ff05dd60d68a72f6377462f9546c1c544a"

  bottle do
    sha256 "e59783409909806a1d958fa589de9cfb5f690b20c8402270258ad88443a2787a" => :sierra
    sha256 "9994eecf827c3d53e39af5e15b30e14b25a4d4cf2ea999e898be64d99788a1df" => :el_capitan
    sha256 "2ba154cc8311481dcbb4f202e854251891a69b3ef3e9e9ac21e25870b6ad6e7f" => :yosemite
  end

  #
  # NOTE: we don't build slice2py, slice2js, slice2rb by default to prevent clashes with
  # the translators installed by the PyPI/GEM/npm packages.
  #

  option "with-additional-compilers", "Build additional Slice compilers (slice2py, slice2js, slice2rb)"
  option "with-java", "Build Ice for Java and the IceGrid GUI app"
  option "without-xcode-sdk", "Build without the Xcode SDK for iOS development (includes static libs)"

  depends_on "mcpp"
  depends_on "lmdb"
  depends_on :java => ["1.8+", :optional]
  depends_on :macos => :mavericks

  def install
    # Ensure Gradle uses a writable directory even in sandbox mode
    ENV["GRADLE_USER_HOME"] = "#{buildpath}/.gradle"

    args = [
      "prefix=#{prefix}",
      "V=1",
      "MCPP_HOME=#{Formula["mcpp"].opt_prefix}",
      "LMDB_HOME=#{Formula["lmdb"].opt_prefix}",
      "CONFIGS=shared cpp11-shared #{build.with?("xcode-sdk") ? "xcodesdk cpp11-xcodesdk" : ""}",
      "PLATFORMS=all",
      "SKIP=slice2confluence #{build.without?("additional-compilers") ? "slice2py slice2rb slice2js" : ""}",
      "LANGUAGES=cpp objective-c #{build.with?("java") ? "java java-compat" : ""}",
    ]
    system "make", "install", *args
  end

  test do
    (testpath / "Hello.ice").write <<-EOS.undent
      module Test
      {
          interface Hello
          {
              void sayHello();
          }
      }
    EOS
    (testpath / "Test.cpp").write <<-EOS.undent
      #include <Ice/Ice.h>
      #include <Hello.h>

      class HelloI : public Test::Hello
      {
      public:
        virtual void sayHello(const Ice::Current&) override {}
      };

      int main(int argc, char* argv[])
      {
        Ice::CommunicatorHolder ich(argc, argv);
        auto adapter = ich->createObjectAdapterWithEndpoints("Hello", "default -h localhost -p 10000");
        adapter->add(std::make_shared<HelloI>(), Ice::stringToIdentity("hello"));
        adapter->activate();
        return 0;
      }
    EOS
    system "#{bin}/slice2cpp", "Hello.ice"
    system ENV.cxx, "-DICE_CPP11_MAPPING", "-std=c++11", "-c", "-I#{include}", "-I.", "Hello.cpp"
    system ENV.cxx, "-DICE_CPP11_MAPPING", "-std=c++11", "-c", "-I#{include}", "-I.", "Test.cpp"
    system ENV.cxx, "-L#{lib}", "-o", "test", "Test.o", "Hello.o", "-lIce++11"
    system "./test"
  end
end
