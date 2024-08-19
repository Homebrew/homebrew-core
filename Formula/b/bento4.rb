class Bento4 < Formula
  desc "Full-featured MP4 format and MPEG DASH library and tools"
  homepage "https://www.bento4.com/"
  url "https://www.bok.net/Bento4/source/Bento4-SRC-1-6-0-641.zip"
  version "1.6.0-641"
  sha256 "8258faf0de7253f2aac016018f33d4a04c16d9060735e14ec8711f84aaedf0c8"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.bok.net/Bento4/source/"
    regex(/href=.*?Bento4-SRC[._-]v?(\d+(?:[.-]\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "44aaa692620d4fcb31befc2f516cd8f15bfa354ab8a63fc631041b7a4735eb20"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "547e1b2f4b7e69e81b629f3de5eb18ed2eff46189f1808d1dd06f79fa2ee8813"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2577abbd894889afbc8a0ead74920524141cdd61a8cc57cebd3c50dbd91d5238"
    sha256 cellar: :any_skip_relocation, sonoma:         "f04de9a02f0026b6af5b97b7b96a1f993cb1221cb091d2ca2dd32ae090d2367b"
    sha256 cellar: :any_skip_relocation, ventura:        "259b55cdeada320d8aa368e18b592a860c086405afb20b7aa243e81f5099b7dc"
    sha256 cellar: :any_skip_relocation, monterey:       "c62d997c1c99c82012bb95a37dbac91fcbe1575c27d9396e0e490dcab23bec95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "625ab4602c107e435c77e5af74109545ba3612ede1c8b6a6e06f5e17aeade282"
  end

  depends_on "cmake" => :build
  depends_on "python@3.12"

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
    system bin/"mp4mux", "--track", test_fixtures("test.m4a"), "out.mp4"
    assert_predicate testpath/"out.mp4", :exist?, "Failed to create out.mp4!"
  end
end
