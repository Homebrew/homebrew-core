class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1186_SDK.zip"
  version "11.86"
  sha256 "b1256882eab96f3cb3f618b13879fd2411589840b700b8aa29a395a8efcba67c"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d03d4c97a8ead3e8e5192bf869cc75eef12ec1411885b0894950d9d0cd12fce0"
    sha256 cellar: :any,                 arm64_sequoia: "aee9b5572cf55a79248ff10b0eb92355b4814d50bde6c1a6025195ebbd847b02"
    sha256 cellar: :any,                 arm64_sonoma:  "9873a7c7519d52203d6c52f1e3bf24179a938f67934f6c405e3b234488356961"
    sha256 cellar: :any,                 sonoma:        "c7b1d1f2d52acf34dbf88c6ddc408e3613d5f2b2fd300319b04bab5e28cbd1e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2d22a06a9235c459a5b42c06ccb4fec7d0bcce8cb3f7252a2a6da6ad5116e10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71a4eaebee9ea83af5b7407b5fc9e9d1f0ac257dbe38e5e2236b473ea3b148ff"
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
