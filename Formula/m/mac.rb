class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1346_SDK.zip"
  version "13.46"
  sha256 "17359c36099b7e1000da40306905f027088ac798fed1cb5e2405c33aaa030f83"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "eac9e72446aa69a6fc3270be308a1c9a0c35864d9aeb9e7e2c5fa8cb8a2f5607"
    sha256 cellar: :any, arm64_tahoe:       "31e7e33da627419479e0e15f29bd7d4b3732b2bdc47e79d7465a36f36488bb7f"
    sha256 cellar: :any, arm64_sequoia:     "d85783d80a40ea9f93f5fc6cd2c5ef99174c2140b25c567e6fc3e14854b409a9"
    sha256 cellar: :any, arm64_linux:       "c89b3163807f25e2d433662f2ee52944fc54eef6d617b62b1c0e2cbdb3bd4a04"
    sha256 cellar: :any, x86_64_linux:      "a69f7e8db1bcd88f8b8c1195c1aeacb6ccbc1b672d7df01cfd28d4cb81c39487"
  end

  depends_on "cmake" => :build

  deny_network_access!

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
