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
    sha256 cellar: :any,                 arm64_monterey: "c3e683a62dedb15887614a90cc3bfb2623389dc3fe8122214425e09274060110"
    sha256 cellar: :any,                 arm64_big_sur:  "53b055a4cce48ba8d476c42ab493501b0f1a602df1e3bf96fafabc391afbedd0"
    sha256 cellar: :any,                 monterey:       "a17908bec123dff4b571cd764b3f8ca4c257102604948ad08d84ef434f34c4d4"
    sha256 cellar: :any,                 big_sur:        "891bafb72353ea0a31cc5d5d027427f20bcc24fa3b52cb2ac9160c3af83c48f6"
    sha256 cellar: :any,                 catalina:       "d6e9d9188462a16603ecf56f26cae67c951c07ca27f770d984a28ea7a3b79180"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13df7bf74da5268255e4c51465da3d69dd6e8b47b85f21889f3cc28cb36ac289"
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
