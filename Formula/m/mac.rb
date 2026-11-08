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
    sha256 cellar: :any, arm64_golden_gate: "e2b170f1f08fae28b6ac8bd0b53140e1e71837636be2392e57267141ad86cf99"
    sha256 cellar: :any, arm64_tahoe:       "f5c76eb11777eacd2c169ef84d7f8c6e65dad1117572be42d5c12a6c703ffaf0"
    sha256 cellar: :any, arm64_sequoia:     "8944a324cb82c349b963ac4f835b7a9cb113b3ce5d24de6c1a0ceb694b609fc1"
    sha256 cellar: :any, arm64_linux:       "77d657d5cefea9492fb59cfa3643d18133c4b25329663cd0cc5ea9be687f3143"
    sha256 cellar: :any, x86_64_linux:      "8c4e87693f31dc095d3d1ce56b0ebb41523c5d8a40b39015f4056bb338444977"
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
