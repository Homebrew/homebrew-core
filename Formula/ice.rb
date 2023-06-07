class Ice < Formula
  desc "Comprehensive RPC framework"
  homepage "https://zeroc.com"
  url "https://github.com/zeroc-ice/ice/archive/v3.7.9.tar.gz"
  sha256 "960b51bb14a0c89d60c0e65cb1d4c6b09fe94d4e4c033c50254f7cc9c862d3c0"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8abb7a70ae78940a3d1b09ee06459393186dca1311ee722d7da1a8045ddebed7"
    sha256 cellar: :any,                 arm64_monterey: "e9b1b953bac6ed187face9857452f19996f45731f8bb02ae6d51e3cb03834de3"
    sha256 cellar: :any,                 arm64_big_sur:  "62654e3d059ad2a1193577026f1d284bb19f851c9abe1951bf521f56c3bc6260"
    sha256 cellar: :any,                 ventura:        "4fb4b35bc9661033888f56a07f283bd15d550cb3499fca1664ad55b999659b11"
    sha256 cellar: :any,                 monterey:       "171f77778ff19662d9f51eaa6b7b211643d12c5be55d5fea148290f2997f6d6c"
    sha256 cellar: :any,                 big_sur:        "cee34743d6cb58200cfdaf51efbe81e0e757a76a84857b1b8bbf2b20db087d5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23b6142583b6ffc1cb0535926ef60acf1e2329df32910d8d814ffe71654acee5"
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
