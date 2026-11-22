class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1350_SDK.zip"
  version "13.50"
  sha256 "64a347668211efbc564a8543b28be612895caddf0a5f317b9404255fcffc0be1"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    manifest_sha256 "4556a165b5bcc35e1b51a66ce4f828de7d9400afd9847f5bacffb659ca5f36c4"
    sha256 cellar: :any, arm64_golden_gate: "2a3b53bb5a1d4a73b84cacedd5df5970ddb46664ec8f599afa70afbc2855f1f4"
    sha256 cellar: :any, arm64_tahoe:       "c4c86fd4eb6772ce773ddcd854622946aa6209fdd56f89a63350b0312b4b4a7b"
    sha256 cellar: :any, arm64_sequoia:     "7e78b491b56c281f0de7cdf7315be3ff77a829f9faf2f377b83e4ab434c91089"
    sha256 cellar: :any, arm64_linux:       "f9b5c818f7ad49003bf52a14ef1612f522ae9d2b90c16a661aed75048a494175"
    sha256 cellar: :any, x86_64_linux:      "70d18763c269d285e3eb638432c91a354ee56cca757b4a39ef37f10ff9d4751e"
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
