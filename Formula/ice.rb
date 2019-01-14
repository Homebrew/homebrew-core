class Ice < Formula
  desc "Comprehensive RPC framework"
  homepage "https://zeroc.com"
  url "https://github.com/zeroc-ice/ice/archive/v3.7.1.tar.gz"
  sha256 "b1526ab9ba80a3d5f314dacf22674dff005efb9866774903d0efca5a0fab326d"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "9bf581e4293f72ccc5c40c22372d54aecd983ec27d3b77b2613b06f7dd11d31b" => :mojave
    sha256 "49e29d8901d39a2520ba488fe5802b777d7f48327a5d56490185f15509febb2e" => :high_sierra
    sha256 "d84b0f6c2f91f784660ce096a5220b32d4f3a1d53af0ed7bdf26d7cbaf6cb698" => :sierra
  end

  depends_on "lmdb"
  depends_on :macos => :mavericks
  depends_on "mcpp"

  patch do
    url "https://github.com/zeroc-ice/ice/compare/v3.7.1..v3.7.1-xcode10.patch?full_index=1"
    sha256 "28eff5dd6cb6065716a7664f3973213a2e5186ddbdccb1c1c1d832be25490f1b"
  end

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
      "LANGUAGES=cpp objective-c",
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
