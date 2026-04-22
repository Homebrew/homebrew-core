class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1267_SDK.zip"
  version "12.67"
  sha256 "f561c20076e73f817f97d13ea21d0a4c5cab4a7c0c5aa7f3e2efb5584596d605"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "628cb155a710bf5cdbfbcbe63f0e1763d1048a32251ae7f9214a678de0337b27"
    sha256 cellar: :any,                 arm64_sequoia: "8367ea9019335bac4b881a4bb1374b0d08b21525d4266b894173767961bacc3d"
    sha256 cellar: :any,                 arm64_sonoma:  "133e2131151b3b1f8510929f67f058f924cfe24f96e09cf6e8fbcc45b850dc63"
    sha256 cellar: :any,                 sonoma:        "0c6df2eb37b7cbdf6f783bba99f010d7382f5924d10ef1e0e290394754357f85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f4ff0aef865c4c80d80767a0f31d8544180fe75b730c48c80b858b7be55eb4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "574fcaabe2d49096415915d47698e7319c8f8544d9aed4d8727ed8c75a4251d8"
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
