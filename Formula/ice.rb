class Ice < Formula
  desc "Comprehensive RPC framework"
  homepage "https://zeroc.com"
  url "https://github.com/zeroc-ice/ice/archive/v3.7.1-xcode10.tar.gz"
  sha256 "cecc7d92a37b57a24c1cd092f083a7ead8812b867f7ac7df2f2324b4c192a718"
  version "3.7.1"
  revision 1

  bottle do
    cellar :any
    sha256 "a6a580aed075a7edcb9f59886bc59b0e6da888623dbf6d81c98f26c4fc472613" => :high_sierra
    sha256 "73cb8a7d1af848b1832d1e837f2a3ec6c35846a8b7431748fd8e175442261df8" => :sierra
    sha256 "319fa13dfe77aa352dd84fb5495fd548fc7d870305fd7c3ee2137c2f298cbf5e" => :el_capitan
  end

  option "with-java", "Build Ice for Java and the IceGrid GUI app"

  depends_on "lmdb"
  depends_on :macos => :mavericks
  depends_on "mcpp"
  depends_on :java => ["1.8+", :optional]

  def install
    ENV.O2 # Os causes performance issues
    # Ensure Gradle uses a writable directory even in sandbox mode
    ENV["GRADLE_USER_HOME"] = "#{buildpath}/.gradle"

    args = [
      "prefix=#{prefix}",
      "V=1",
      "MCPP_HOME=#{Formula["mcpp"].opt_prefix}",
      "LMDB_HOME=#{Formula["lmdb"].opt_prefix}",
      "CONFIGS=shared cpp11-shared xcodesdk cpp11-xcodesdk",
      "PLATFORMS=all",
      # We don't build slice2py, slice2js, slice2rb to prevent clashes with
      # the translators installed by the PyPI/GEM/npm packages.
      "SKIP=slice2confluence slice2py slice2rb slice2js",
      "LANGUAGES=cpp objective-c #{build.with?("java") ? "java java-compat" : ""}",
    ]
    system "make", "install", *args
  end

  test do
    (testpath / "Hello.ice").write <<~EOS
      module Test
      {
          interface Hello
          {
              void sayHello();
          }
      }
    EOS
    (testpath / "Test.cpp").write <<~EOS
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
