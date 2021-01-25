class Bento4 < Formula
  desc "Full-featured MP4 format and MPEG DASH library and tools"
  homepage "https://www.bento4.com/"
  url "https://www.bok.net/Bento4/source/Bento4-SRC-1-6-0-637.zip"
  version "1.6.0-637"
  sha256 "ac6628aa46836994d52823a7dddc604d4f32b04c08bde73dcbe5a446a7715420"

  livecheck do
    url "https://www.bok.net/Bento4/source/"
    regex(/href=.*?Bento4-SRC[._-]v?(\d+(?:[.-]\d+)+)\.zip/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d08015d67e5e8ae84f6fc0e7fe51055cb1e2aa5834f31903573466cca45a6c97" => :big_sur
    sha256 "fe8e42701b024238775a67bdbdcb25c212f2a083f1584cddc3cb7de6abba7814" => :arm64_big_sur
    sha256 "2efea32fecade412d22f6fd935b8cce2c551827b89525cabed6d6a4a2de75c31" => :catalina
    sha256 "3263f0b113098ea8e9657b57b6bb6de2eba407239ca45b49c46004c1f2731e71" => :mojave
    sha256 "5a4aeeb90a41317022137325da9ca78acb8223a3af1ac019e135cbdb7972a251" => :high_sierra
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
