class Bento4 < Formula
  desc "Full-featured MP4 format and MPEG DASH library and tools"
  homepage "https://www.bento4.com/"
  url "https://github.com/axiomatic-systems/Bento4/archive/v1.5.1-628.tar.gz"
  version "1.5.1-628"
  sha256 "e6fce0b1015698ff2f4f99e81c516ec042b351de052c885da7f82aebda56b65a"

  bottle do
    cellar :any_skip_relocation
    sha256 "f982d297d2d65bb5e51c29602fea985f0abe399077b555f805920ebd821b583a" => :catalina
    sha256 "70b14caee7dee4170ef309393e122f16ecb677943a3f2c9d1d40747764bea18d" => :mojave
    sha256 "d1977eae032f7de54129952c0178bf183aa3909a89826333b185a36e43c780f0" => :high_sierra
    sha256 "85ca3dbb13344503507d939edb90dfee89f3d8f342c1fadbb1494e983d9251cf" => :sierra
  end

  depends_on :xcode => :build
  depends_on "python"

  conflicts_with "gpac", :because => "both install `mp42ts` binaries"
  conflicts_with "mp4v2",
    :because => "both install `mp4extract` and `mp4info` binaries"

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
