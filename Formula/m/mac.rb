class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1206_SDK.zip"
  version "12.06"
  sha256 "a469c74be43052ac5b722efb4b003953b662dee4cefbb8d030b24412286266d9"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8a25ee0b0634346be41f579a0581f5fba9a5f923a4d681bd29a97b89d200fa92"
    sha256 cellar: :any,                 arm64_sequoia: "ce6add4791d70b99683eb20dc3a67fa8e2c0d0c51c22086877f319f7690d9191"
    sha256 cellar: :any,                 arm64_sonoma:  "5a96d7e33f34dd871b6441a152e96aeb517ba556a1c67789f8d480a615a40fef"
    sha256 cellar: :any,                 sonoma:        "97d4d6bd8492a1c41c32f888c635183d668b3795bf0b3411226e444cf7a0a26b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6efb8b43afd772a784bd5c6c4374c3d77de3302e874812dc2d82d07dabe4bfe5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54a8f9d0a5293c69d06f76c1869d63894e9869a3cea0caf8a295aa4eed225310"
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
