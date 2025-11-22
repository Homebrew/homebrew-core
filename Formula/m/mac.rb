class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1187_SDK.zip"
  version "11.87"
  sha256 "bc00f04e5ee12ad7fc29bc9fe66e37cc365cc235213e9dcc1d7647908931dec6"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9b85a6210b38b363941c85ba162afff5878f2472229d9627c7f53333033c0182"
    sha256 cellar: :any,                 arm64_sequoia: "3ce0880a8ab314731013e66d1a3fe2e5f22235ec7e825e40566dc9cd544f5184"
    sha256 cellar: :any,                 arm64_sonoma:  "c0bed959796ffc1cb5e40b3afb7dfa7c5cf53ce79eb2dffb1e19679f1d2bacff"
    sha256 cellar: :any,                 sonoma:        "982fd6df78e5a1246c693c3086c967637fcb50d9522f471cee9641ccce6eeda2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6eb223c1aa9a5a24bb57279c74da9842f340c81aa51f4b5389264b7275347f68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77602d101e7d56b00120041ebcfe572572f7a122b79efead9d869e9f966e0da6"
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
