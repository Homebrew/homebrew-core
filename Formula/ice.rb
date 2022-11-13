class Ice < Formula
  desc "Comprehensive RPC framework"
  homepage "https://zeroc.com"
  url "https://github.com/zeroc-ice/ice/archive/v3.7.8.tar.gz"
  sha256 "f2ab6b151ab0418fab30bafc2524d9ba4c767a1014f102df88d735fc775f9824"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "49d742e66f44d924bc3b625847a4845f6edeab5ea687e257d4cb235044650401"
    sha256 cellar: :any,                 arm64_monterey: "6650cecd9095c96c494edf121678aa8e89566f8d0bdfe4d5540c7222b951179e"
    sha256 cellar: :any,                 arm64_big_sur:  "8afe5f234ae949865fddca70ab16e15e33319f286075089f752f6b146abeba5f"
    sha256 cellar: :any,                 monterey:       "aa346abe07a352e4ea23803bc9c7bf73a95e6f2efa026d5ca47ea8d109f6dfae"
    sha256 cellar: :any,                 big_sur:        "1e078df1a92a1cd953d2d6ec66363ea8ca52e731c73bd650bc4156eee6f45d9f"
    sha256 cellar: :any,                 catalina:       "80efcfad8576c1357f1932dce4b5d46910839018fba3f006e433cb29f228ca23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f73974710d6af39e7bca7ada86590b5be72aa9304bc4ee6af062fdf6e20203d4"
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

    # Fails with Xcode < 12.5
    inreplace "cpp/include/Ice/Object.h", /^#.+"-Wdeprecated-copy-dtor"+/, "" if MacOS.version <= :catalina

    system "make", "install", *args

    # We install these binaries to libexec because they conflict with those
    # installed along with the ice packages from PyPI, RubyGems and npm.
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

    (testpath/"Test.cpp").write <<~EOS
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
        auto adapter = ich->createObjectAdapterWithEndpoints("Hello", "default -h 127.0.0.1 -p #{port}");
        adapter->add(std::make_shared<HelloI>(), Ice::stringToIdentity("hello"));
        adapter->activate();
        return 0;
      }
    EOS

    system bin/"slice2cpp", "Hello.ice"
    system ENV.cxx, "-DICE_CPP11_MAPPING", "-std=c++11", "-c", "-I#{include}", "-I.", "Hello.cpp"
    system ENV.cxx, "-DICE_CPP11_MAPPING", "-std=c++11", "-c", "-I#{include}", "-I.", "Test.cpp"
    system ENV.cxx, "-L#{lib}", "-o", "test", "Test.o", "Hello.o", "-lIce++11", "-pthread"
    system "./test"
  end
end
