class Bento4 < Formula
  desc "Full-featured MP4 format and MPEG DASH library and tools"
  homepage "https://www.bento4.com/"
  url "https://www.bok.net/Bento4/source/Bento4-SRC-1-6-0-632.zip"
  version "1.6.0-632"
  sha256 "faa3a406dc24c3d34d29661bbbe94b42c7f7deee9a5c624696a055bb9b7da6ad"

  bottle do
    cellar :any_skip_relocation
    sha256 "753d0676bfb53c3a83586ab89acd95245a6ea3907c367858d81cd950cbfa0ffb" => :catalina
    sha256 "6a56425ed7103855772dd0979d63827d53ee37e61e3dd92dbaa3e04755689e5f" => :mojave
    sha256 "615ee776852cf976005c1c55142fb68fa52a48eb366f629a24b361a70cfcab75" => :high_sierra
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
