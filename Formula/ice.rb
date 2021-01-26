class Ice < Formula
  desc "Comprehensive RPC framework"
  homepage "https://zeroc.com"
  url "https://github.com/zeroc-ice/ice/archive/v3.7.5.tar.gz"
  sha256 "36bf45591a95e6ee7216153d45d8eca05ff00c1da35608f0c400e6ddc8049da9"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any
    sha256 "2b1fb05867bdbc31844aa82742923e39bc03da19c95aeab06ef465abbcbf0041" => :big_sur
    sha256 "ed026c50e889b8eab856b8310d9b57a5a09487775b85e0fd3a745c3703234aa3" => :catalina
    sha256 "d8ddc0c493286e78174f61eb8feb7af105c6c4b33580435f6df4515aefa56b0a" => :mojave
    sha256 "d80dfe41a72184cfb820940e926acd8204d5338327b0ff1007fe77e7662a8164" => :high_sierra
  end

  depends_on "lmdb"
  depends_on "mcpp"

  def install
    args = [
      "prefix=#{prefix}",
      "V=1",
      "USR_DIR_INSTALL=yes", # ensure slice and man files are installed to share
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
