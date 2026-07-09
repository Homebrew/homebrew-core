class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1318_SDK.zip"
  version "13.18"
  sha256 "39cbcdbaf7f3e47cde7cfcb671b7a52ba05ee04c91a986d3eca6a653489c6954"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8a45e053a0ef9183bdc29d76ce001298ff8f6265530ceb47c8578b2278e481e5"
    sha256 cellar: :any, arm64_sequoia: "e75483c21415dc973003d007e8d368211c7dfc8df57866d016787dcb29d958ad"
    sha256 cellar: :any, arm64_sonoma:  "4fefcdb63af44d9a8af28ee774a2cc96b39ffc3237de2d3afc612726ca2f31c0"
    sha256 cellar: :any, sonoma:        "e28f4c09a1a2662b20f8756a66807ea12bcef559f53ee911853b8b4d6f077266"
    sha256 cellar: :any, arm64_linux:   "b410acb62ce0fa7c39fd248a92a6242231cf9d34b7530479d7ed57e5a9ddfc0f"
    sha256 cellar: :any, x86_64_linux:  "4c03e94034b4564c0b4cf3eb018fbe296c2e87472d8a930a027b3babb695654c"
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
