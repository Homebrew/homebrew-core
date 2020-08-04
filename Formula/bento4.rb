class Bento4 < Formula
  desc "Full-featured MP4 format and MPEG DASH library and tools"
  homepage "https://www.bento4.com/"
  url "https://www.bok.net/Bento4/source/Bento4-SRC-1-6-0-632.zip"
  version "1.6.0-632"
  sha256 "faa3a406dc24c3d34d29661bbbe94b42c7f7deee9a5c624696a055bb9b7da6ad"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "c2a563a7f037d33921334541e706a3f98ae0556ff08ba3e33992d4c26342de19" => :catalina
    sha256 "f74dc8941419a6fffe52606dd40e2f612a8b8713ea6249fc6d20b6f3656e1859" => :mojave
    sha256 "39cf05c54bc595fa014196b8f0fa0847e2d39d25e720bf9c6b581a578a77631b" => :high_sierra
  end

  depends_on xcode: :build
  depends_on "python@3.8"

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
