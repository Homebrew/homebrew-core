class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1326_SDK.zip"
  version "13.26"
  sha256 "3fdb516db15cc754eb2db1d255e405a8142fbb115eccdf51b0fa07b84305b6ac"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d133f4caebaad21de19d590d596a999506c68a22437d7554e2b8ac1f17c7fca7"
    sha256 cellar: :any, arm64_sequoia: "1461a7f57002ee711b5aa92f09061228432550e8833a17da11abd98152c758ba"
    sha256 cellar: :any, arm64_sonoma:  "de58c9e3a4bfb0f7be692be850dd89258ef1edf4cf080d4776189ecee5e01599"
    sha256 cellar: :any, sonoma:        "e46600fa531eecb386df53953ae675a5839c38466c2795b09bec2bab090c30a7"
    sha256 cellar: :any, arm64_linux:   "271e74692e012850073394e2c8617c673f0475b9bbd6dfae764edf3c37c7edd8"
    sha256 cellar: :any, x86_64_linux:  "799d1be9ac089f167b9ee91c977bbe222a61d16c05edb1ddc34ffccc6fce9583"
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
