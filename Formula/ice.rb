class Ice < Formula
  desc "Comprehensive RPC framework"
  homepage "https://zeroc.com"
  url "https://github.com/zeroc-ice/ice/archive/v3.7.2.tar.gz"
  sha256 "e329a24abf94a4772a58a0fe61af4e707743a272c854552eef3d7833099f40f9"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "9bf581e4293f72ccc5c40c22372d54aecd983ec27d3b77b2613b06f7dd11d31b" => :mojave
    sha256 "49e29d8901d39a2520ba488fe5802b777d7f48327a5d56490185f15509febb2e" => :high_sierra
    sha256 "d84b0f6c2f91f784660ce096a5220b32d4f3a1d53af0ed7bdf26d7cbaf6cb698" => :sierra
  end

  depends_on "lmdb"
  depends_on "mcpp"

  def install
    ENV.O2 # Os causes performance issues

    args = [
      "prefix=#{prefix}",
      "V=1",
      "MCPP_HOME=#{Formula["mcpp"].opt_prefix}",
      "LMDB_HOME=#{Formula["lmdb"].opt_prefix}",
      "CONFIGS=shared cpp11-shared xcodesdk cpp11-xcodesdk",
      "PLATFORMS=all",
      "SKIP=slice2confluence",
      "LANGUAGES=cpp objective-c",
    ]
    system "make", "install", *args

    (libexec/"bin").mkpath
    %w[slice2py slice2rb slice2js].each do |r|
      mv bin/r, libexec/"bin"
    end
  end

  def caveats; <<~EOS
    slice2py, slice2js and slice2rb were installed in:

      #{opt_libexec}/bin

    You may wish to add this directory to your PATH.
  EOS
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
