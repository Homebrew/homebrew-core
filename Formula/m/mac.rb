class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1205_SDK.zip"
  version "12.05"
  sha256 "d296d47195e735b452eabd4dc308dabdb124b28c79df200384ab76cfa42456c2"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a4ee17b135508db0b9ee2cf9d26404c7810d0b35e7ce923a94474e47c9f044a3"
    sha256 cellar: :any,                 arm64_sequoia: "bc605e1f521fd0b291161dfec704237131882c6c80c767199f396642d3458245"
    sha256 cellar: :any,                 arm64_sonoma:  "34d0bd847631e981dbaa67e6c11fa82eb2411000a15fd925c1f028c13e7ccab0"
    sha256 cellar: :any,                 sonoma:        "f09484fec3cbb374f63b6a4c1dccfa076f72b5aaffaadc7c6c24b9feef7b86eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aaf93ab982cc758e00891ce59e6ae478c9882cfed4c890e65765f6bc46fa9dd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c522a037e1f3eb84d6f0c89d7e70b76704b6667da891902928e134356b62423"
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
