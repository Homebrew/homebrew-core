class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1120_SDK.zip"
  version "11.20"
  sha256 "ed443bca473fba3664f118934ccfccc3bf93c20ca0598a2c7339fe31cd0cf16d"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "32f11534d5fea66c39ef8bb42837237378348c764064cbe1b532762b0a36a7e9"
    sha256 cellar: :any,                 arm64_sonoma:  "ac67de3e5cad4fc1697fb4ca30876915cd5ffa4cf319214f0742939b282638a8"
    sha256 cellar: :any,                 arm64_ventura: "46745827e6e5aa12eaeb354481b94f084cf5121bbb5a237decc611604240a604"
    sha256 cellar: :any,                 sonoma:        "462fd711577164a45c0839ef9fc1bf9c166a57556684a85f94c234e40a43d6e0"
    sha256 cellar: :any,                 ventura:       "0f442f5a471c6f6e2d06c0e889959d8911e1c2f1b52cb3329d7a43c2b3cccdce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6b64598c211d62e2586bbcb854ae29eff57f592703092f86d0b279587ac3703"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36a9f95951004cb28f7eb77504814bd1a3179190dc0bab32ab2584502d68b148"
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
