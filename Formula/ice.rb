class Ice < Formula
  desc "Comprehensive RPC framework"
  homepage "https://zeroc.com"
  url "https://github.com/zeroc-ice/ice/archive/v3.7.6.tar.gz"
  sha256 "75b18697c0c74f363bd0b85943f15638736e859c26778337cbfe72d31f5cfb47"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "4f4c56b0eeac619b1f7f90f3689fa92c2114e4cf3a1718e7a6367fc5d1220885"
    sha256 cellar: :any, arm64_big_sur:  "aba8e77b6144ab02730670f94205ea2de3efd4581b6e1f167ae1ae48bd5405ae"
    sha256 cellar: :any, monterey:       "9f3c03bea4c11cd4872abb3a3bd8adc413e34c6a34d6055a85274e1e68e1fc52"
    sha256 cellar: :any, big_sur:        "0c63ce1c5ea37d98b1cd64411e5c6d9e445330c44ab6cb864bd1995b1d5fb91f"
    sha256 cellar: :any, catalina:       "107f893606aa135531ca17cbb0328f1e664040d36c5373e83a856ba525ba3647"
  end

  depends_on "lmdb"
  depends_on macos: :catalina
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
    inreplace "cpp/include/Ice/Object.h", /^#.+"-Wdeprecated-copy-dtor"+/, "" # fails with Xcode < 12.5
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
