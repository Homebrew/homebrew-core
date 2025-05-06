class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1110_SDK.zip"
  version "11.10"
  sha256 "fe6f481e15eb03e0d4e0f8144a4fd1aff4398c77c419ff36aec99e807b38a54c"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1a28e1060c1e6d8c7bfbfd5b9ff29824999313a5eca8c64b3a59a5fe6a6eceed"
    sha256 cellar: :any,                 arm64_sonoma:  "9455b4f32c8a08bafce683674d6ad6c2f4ea03f0dc6b505654b307d97a20581d"
    sha256 cellar: :any,                 arm64_ventura: "1ae807cabcfc1019390293032251dc89eddaba94234e575e1ce69f5940b1b052"
    sha256 cellar: :any,                 sonoma:        "44f4599deecb2327079d5f90e0c9282956f1576eaaae3550f81f435e57519112"
    sha256 cellar: :any,                 ventura:       "bc4a5536617910ba0ee64c79e5a733b0aec1aa943c68a35409641fff9f879248"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6649cc3d8da73a30b57b8adb05321d90f3717693e93d5c19f8eeec8a82854d98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c5de0aaca2f22685bf39cc889e903f445f9d0359669d7781d0e3c5dd9834b18"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"mac", test_fixtures("test.wav"), "test.ape", "-c2000"
    system bin/"mac", "test.ape", "-V"
    system bin/"mac", "test.ape", "test.wav", "-d"
    assert_equal Digest::SHA256.hexdigest(test_fixtures("test.wav").read),
                 Digest::SHA256.hexdigest((testpath/"test.wav").read)
  end
end
