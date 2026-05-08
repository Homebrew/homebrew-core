class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1284_SDK.zip"
  version "12.84"
  sha256 "0e9ddd5dba51b43f409e098b3a6d1e8df355ded8039cdc3083338ebce31c1252"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3995bf4a7038867e09b9813b607708ade2cc06fb475d113086573aaef2e80f52"
    sha256 cellar: :any,                 arm64_sequoia: "c45be871a5584dd182a08d0364dbd43fe1811c0e70e08e241cb89a1ff28c9c49"
    sha256 cellar: :any,                 arm64_sonoma:  "2503b677471272687267f8417f1e2262990f0ab58fb682634473d01159f0f5c5"
    sha256 cellar: :any,                 sonoma:        "2bee4995ae0d0b7e185045ee5ceb2f351f1b97ad3605c58b9f0bd5b0d6c2184f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bcdb189a49d3840f3d2ffc562c442c5f87657b06188988be22c97f06a9403bb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9103e50d93e25a9f85c038378fbdaf6b86278ad039935f335595ea3e0d08960"
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
