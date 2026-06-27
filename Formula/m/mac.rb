class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1306_SDK.zip"
  version "13.06"
  sha256 "d8a6483dd011e481930beaaa360951a03fea9764e2c7755feb4a67f3564c6d86"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fe5af28b6f1c32be486b6c1fc9b3903b25d6a5b9bd5a56b1b141ddcde00376db"
    sha256 cellar: :any, arm64_sequoia: "32e66f125572185e77399b597309a1b2c452100ca417c08f69a0de12681b8a2f"
    sha256 cellar: :any, arm64_sonoma:  "d754ee18818b2905004591750979a1b8e1fc8e1b2a663911975ca6d53d955858"
    sha256 cellar: :any, sonoma:        "5840e4665238618f2e1fdbbb8bac8459b675b7f8ba37ce13252ae0db80056b70"
    sha256 cellar: :any, arm64_linux:   "f0515bc0be564dd18850d21226cbd5b009dcf3db9637b4ddffaa7cf08ccbe917"
    sha256 cellar: :any, x86_64_linux:  "3b7502126deb3e83235efca320b3e5ffb3643a92013217e619925baa8263a874"
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
