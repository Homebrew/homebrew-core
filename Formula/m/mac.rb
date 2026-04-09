class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1263_SDK.zip"
  version "12.63"
  sha256 "0e8ae89f1e13b3c20d8af8d85c5198305c2332d3742042a8f41275a70e333cbc"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2fbcd154bca9e8d911a2388fc64bcd7b1384243b54a626a159d7a684033b10a6"
    sha256 cellar: :any,                 arm64_sequoia: "06a1dc1f169cd3900cac7d8920661e6fee579096ae16c2ffc83db61d502cdc60"
    sha256 cellar: :any,                 arm64_sonoma:  "61c07951b1a419d0386379b09bc164adc0b756bb965b34efbb062209c3f79779"
    sha256 cellar: :any,                 sonoma:        "28e6f2dc870438885d482e1cf5796cb0c9e6ed98b4f18d298f9c4fc0905bd675"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20bff3262fe54f61d10752690faf895ad2db6458b9221ef388ff0a3cfd92d7c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27349d32dca41b9015896a0a4cdcad2dfc66a772ab05b8efaf6208e70d32e6d1"
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
