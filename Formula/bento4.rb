class Bento4 < Formula
  desc "Full-featured MP4 format and MPEG DASH library and tools"
  homepage "https://www.bento4.com/"
  url "https://www.bok.net/Bento4/source/Bento4-SRC-1-6-0-632.zip"
  version "1.6.0-632"
  sha256 "faa3a406dc24c3d34d29661bbbe94b42c7f7deee9a5c624696a055bb9b7da6ad"
  revision 2

  livecheck do
    url "https://www.bok.net/Bento4/source/"
    regex(/href=.*?Bento4-SRC[._-]v?(\d+(?:[.-]\d+)+)\.zip/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "3b5840c8f8c049032e39a19a571a616a3faf3157f874f1ed0e22e5e248a3b59b" => :catalina
    sha256 "c4312f145319b6f1b48d1413d897e7c98f3be60c19379f2fcf7692b65a585fcf" => :mojave
    sha256 "2c8431f14ae7303a9738c8d036a03763835b2146446c28dc464f647c9caab04d" => :high_sierra
  end

  depends_on xcode: :build
  depends_on "python@3.9"

  on_linux do
    depends_on "cmake" => :build
  end

  conflicts_with "gpac", because: "both install `mp42ts` binaries"
  conflicts_with "mp4v2",
    because: "both install `mp4extract` and `mp4info` binaries"

  def install
    cd "Build/Targets/universal-apple-macosx" do
      xcodebuild "-target", "All", "-configuration", "Release", "SYMROOT=build"
      programs = Dir["build/Release/*"].select do |f|
        next if f.end_with? ".dylib"
        next if f.end_with? "Test"

        File.file?(f) && File.executable?(f)
      end
      bin.install programs
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
