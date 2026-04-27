class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1272_SDK.zip"
  version "12.72"
  sha256 "d4a51a3acf635e475e37c64f51afaab126ff99389b5213b9c1f5533e672390cb"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a9bc5fa7263f6948d9bfc7e92e20c84c305cd8655f893968e2f1d8ea207a3a7b"
    sha256 cellar: :any,                 arm64_sequoia: "2027cefd78d36a36e036bb4460c9c450381f72fb18b91bb5774143a66e543501"
    sha256 cellar: :any,                 arm64_sonoma:  "a3ec1f54f9a83024bbf86a8493627788965b0d46967cc4d1a6fa9bd6bab6b6e0"
    sha256 cellar: :any,                 sonoma:        "110be3ae8f5d9f49a38a0ac23ee1463f04059ae4ce0f4db0c061a2cbe7710ba8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6b07af0f70ea9b96ffcf813f6a1ef429742c0963008c1f00c9fe9eba1f238a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2816dedeb3c842cd731644e1451421b589f70a6b75f36ba2c093373d5d1fba32"
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
