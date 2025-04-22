class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1108_SDK.zip"
  version "11.08"
  sha256 "9b5350a3caeba8f49aa46b95109750913b782fa73e2398f67d724e953812dcf7"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "08df0b75d9848eca59ecb1b5577f49a377c1369652b6c7d2ec258bb9e692771e"
    sha256 cellar: :any,                 arm64_sonoma:  "233c231067d746fa9f58c93f40fa1ad0fd6d6ed3f4a69b7686ebac97fe317528"
    sha256 cellar: :any,                 arm64_ventura: "be5d30bf9dcf5d945b231e78525832e2c5fcfa659fdd36f0783930a043f23c1e"
    sha256 cellar: :any,                 sonoma:        "0c9f1891ee3b3a3d0806f6183981944b5a68b03f4e562b87fae67e1c6f1d2254"
    sha256 cellar: :any,                 ventura:       "ee090e62047ae8e4f30eebfca4b494664cc697fd353fba527421f0095e1244c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b24af25da7cd973d0e83ee92baaec4e5a409f7ed0eed3a4396898c9aed2a0af9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab770f7a5d948df8da7006a9141ffecb25144bf789cc2da56b2e115635cc0f1f"
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
