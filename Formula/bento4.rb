class Bento4 < Formula
  desc "Full-featured MP4 format and MPEG DASH library and tools"
  homepage "https://www.bento4.com/"
  url "https://www.bok.net/Bento4/source/Bento4-SRC-1-6-0-638.zip"
  version "1.6.0-638"
  sha256 "e9cb2d60ca681663c071e6552c5c570ba45fde558654d8b40f0d5e627d867948"

  livecheck do
    url "https://www.bok.net/Bento4/source/"
    regex(/href=.*?Bento4-SRC[._-]v?(\d+(?:[.-]\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fe8e42701b024238775a67bdbdcb25c212f2a083f1584cddc3cb7de6abba7814"
    sha256 cellar: :any_skip_relocation, big_sur:       "d08015d67e5e8ae84f6fc0e7fe51055cb1e2aa5834f31903573466cca45a6c97"
    sha256 cellar: :any_skip_relocation, catalina:      "2efea32fecade412d22f6fd935b8cce2c551827b89525cabed6d6a4a2de75c31"
    sha256 cellar: :any_skip_relocation, mojave:        "3263f0b113098ea8e9657b57b6bb6de2eba407239ca45b49c46004c1f2731e71"
    sha256 cellar: :any_skip_relocation, high_sierra:   "5a4aeeb90a41317022137325da9ca78acb8223a3af1ac019e135cbdb7972a251"
  end

  depends_on xcode: :build
  depends_on "python@3.9"

  on_linux do
    depends_on "cmake" => :build
  end

  conflicts_with "gpac", because: "both install `mp42ts` binaries"
  conflicts_with "mp4v2", because: "both install `mp4extract` and `mp4info` binaries"

  def install
    on_macos do
      cd "Build/Targets/universal-apple-macosx" do
        xcodebuild "-target", "All", "-configuration", "Release", "SYMROOT=build"
        programs = Dir["build/Release/*"].select do |f|
          next if f.end_with? ".dylib"
          next if f.end_with? "Test"

          File.file?(f) && File.executable?(f)
        end
        bin.install programs
      end
    end
    on_linux do
      mkdir "cmakebuild" do
        system "cmake", "..", *std_cmake_args
        system "make"
        programs = Dir["./*"].select do |f|
          File.file?(f) && File.executable?(f)
        end
        bin.install programs
      end
    end

    rm Dir["Source/Python/wrappers/*.bat"]
    inreplace Dir["Source/Python/wrappers/*"],
              "BASEDIR=$(dirname $0)", "BASEDIR=#{libexec}/Python/wrappers"
    libexec.install "Source/Python"
    bin.install_symlink Dir[libexec/"Python/wrappers/*"]
  end

  test do
    system "#{bin}/mp4mux", "--track", test_fixtures("test.m4a"), "out.mp4"
    assert_predicate testpath/"out.mp4", :exist?, "Failed to create out.mp4!"
  end
end
