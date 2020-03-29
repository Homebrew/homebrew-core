class Ice < Formula
  desc "Comprehensive RPC framework"
  homepage "https://zeroc.com"
  url "https://github.com/zeroc-ice/ice/archive/v3.7.3.tar.gz"
  sha256 "7cbfac83684a7434499f165e784a7a7bb5b89140717537067d7b969eccc111eb"
  revision 1

  bottle do
    cellar :any
    sha256 "0f6f68633091f43037d3e089c7a0b1d6eae005b965b6cda36df27e126d6ceb64" => :catalina
    sha256 "b1e4e7562f96c13849068d9d1b4e8e328715b18fa7cfafed5402fc9488cf274c" => :mojave
    sha256 "4e43e7f8bd3b7f971f5127c9817c3109015a1826fac7aa6ab4f6f493cf5a38aa" => :high_sierra
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
