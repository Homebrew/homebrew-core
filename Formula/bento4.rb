class Bento4 < Formula
  desc "Full-featured MP4 format and MPEG DASH library and tools"
  homepage "https://www.bento4.com/"
  url "https://www.bok.net/Bento4/source/Bento4-SRC-1-6-0-639.zip"
  version "1.6.0-639"
  sha256 "3c6be48e38e142cf9b7d9ff2713e84db4e39e544a16c6b496a6c855f0b99cc56"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.bok.net/Bento4/source/"
    regex(/href=.*?Bento4-SRC[._-]v?(\d+(?:[.-]\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6aca82528cbf94a1ef17a0d70030a8d1b283c952123562d903bcde469c0ed1c9"
    sha256 cellar: :any_skip_relocation, big_sur:       "bcd39d888aaf6b72f83e5f6235744ae11acb9e1330ff0766310fd2b1a9efee3d"
    sha256 cellar: :any_skip_relocation, catalina:      "bef6df08fd97cb7824c49fd890ae11184fd90fadb789aa80cd699a0e0f0a91b1"
    sha256 cellar: :any_skip_relocation, mojave:        "7c1b3a269b3fbeb4768896aefe7a224fc1b7ceb4072ad60f752e3ac4e98031cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c8ed04f699e29cb193e4f035d4bb876bf1f8eb9b668689d87bfd0da5b925ebd"
  end

  depends_on xcode: :build
  # artifact does not produce arm64 native binaries
  depends_on arch: :x86_64
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
