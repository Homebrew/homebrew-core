class Ice < Formula
  desc "Comprehensive RPC framework"
  homepage "https://zeroc.com"
  url "https://github.com/zeroc-ice/ice/archive/v3.7.3.tar.gz"
  sha256 "7cbfac83684a7434499f165e784a7a7bb5b89140717537067d7b969eccc111eb"
  revision 1

  bottle do
    cellar :any
    sha256 "3fdec454548d572b2f8524b326570a404c227e546ec4040d302ddb46f7949f07" => :catalina
    sha256 "6a0804cfa9537a78d77b4c0304fb8ade3238795c3b152ddf2b5f86f05c770205" => :mojave
    sha256 "5eced597ad649064bb8386c1b5a19e43f4774ae56587f280eb988fd10cd2d9a1" => :high_sierra
  end

  depends_on "lmdb"
  depends_on "mcpp"

  # Build failure and code generation (slice2swift) fixes for Swift 5.2
  # Can be removed in next upstream release
  patch do
    url "https://github.com/zeroc-ice/ice/commit/c6306e50ce3e5d48c3a0b0e3aab4129c3f430eeb.patch?full_index=1"
    sha256 "09178ee9792587411df6592a4c2a6d01ea7b706cf68d0d5501c0e91d398e0c38"
  end

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

  def caveats
    <<~EOS
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
