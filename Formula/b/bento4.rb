class Bento4 < Formula
  desc "Full-featured MP4 format and MPEG DASH library and tools"
  homepage "https://www.bento4.com/"
  url "https://www.bok.net/Bento4/source/Bento4-SRC-1-6-0-640.zip"
  version "1.6.0-640"
  sha256 "abc319b553d6c3540e38e30a6286ef113118c1298ac80f37994a376db331ab6e"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.bok.net/Bento4/source/"
    regex(/href=.*?Bento4-SRC[._-]v?(\d+(?:[.-]\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dec8488f6ef337a04b19994c9f9c2b74163bfd39322be5bf4f0404af8d524239"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "900876febd374ebf619e873b0f256adb7d1cf519828244b9671a0c1d5ca5a297"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bfbfeb18012c08aa6a890bbdbecd2969ba78914f725695af62759d3d798a910f"
    sha256 cellar: :any_skip_relocation, ventura:        "e7b9eeb3fd27cc3368b0a8e72a1a4e04c7fede2460e2d2571d3f40b6d59d1aed"
    sha256 cellar: :any_skip_relocation, monterey:       "a118616ec94b65a2094a95ff8d27c503cdc13c6fa26219a2a49d92f30229351d"
    sha256 cellar: :any_skip_relocation, big_sur:        "a56c4c159c3bbd417497939606391440e3ef19d365029affe28a432c285d49ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bc0c7bb647667c0584fc4e8f21d68621898f22de89d13c7f984034c800f0f00"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11"

  conflicts_with "gpac", because: "both install `mp42ts` binaries"
  conflicts_with "mp4v2", because: "both install `mp4extract` and `mp4info` binaries"

  def install
    system "cmake", "-S", ".", "-B", "cmakebuild", *std_cmake_args
    system "cmake", "--build", "cmakebuild"
    system "cmake", "--install", "cmakebuild"

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
