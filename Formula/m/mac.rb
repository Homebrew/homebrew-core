class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1143_SDK.zip"
  version "11.43"
  sha256 "9c49c123b95b36d3d86798ebfef5dc96c96c6c1ba02291290d6a9397f1fc3fd1"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "21e81e5a55b2873e431691731891ffcba0cf9aef87078e5ef7e84c949f4611bb"
    sha256 cellar: :any,                 arm64_sequoia: "d870d308a2fe0cfb5a4f8fafc4dc4a091d8557da02a93c2dfed303f76c9a1fd1"
    sha256 cellar: :any,                 arm64_sonoma:  "eb3e38806be70d38dbdeaf071e8a52f48f655715bd52af97bdde15558e44331c"
    sha256 cellar: :any,                 arm64_ventura: "a606fc5bf071d680bf4e89d53101b7b465a981e427efa37d9da9e58018d9c5a8"
    sha256 cellar: :any,                 sonoma:        "064fbba8c77790e8900ff6a2de3e459effcab01f3d8158e7d24a19e7ead715a8"
    sha256 cellar: :any,                 ventura:       "d331770c80b14727c88426fcdf2a7ff71329cb75ad52cfc5db35c2f71747e00a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e75dcfc392557eefc3580535a31ea59fefd39091e57a2e8ff79c03a6de5ba818"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e4c1cdbc363ecf20f837c1522dfd0de1f584ee8281be2e38378927beac0b43c"
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
