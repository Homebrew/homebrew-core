class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1154_SDK.zip"
  version "11.54"
  sha256 "6f825a606e474a03729eb50d8b6967c74dbd1863c172e0732d836bebd9813dfc"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5c743728ac3caf242ec168c9aca92143f62545139a9c1a3d8682e59ceb6bcf74"
    sha256 cellar: :any,                 arm64_sequoia: "1b44254fa3f61edec66c79d5210f599cf6d359602af54f51392a09da79420588"
    sha256 cellar: :any,                 arm64_sonoma:  "093cd382f7c57c1aea07dcd1ca4e9fd2a798604e0610d4895c6abb974299d203"
    sha256 cellar: :any,                 sonoma:        "084ffaecf395f0c086a1fbf8175a32ac4c62d7afdffa099527a5173f43f88add"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd5f3ef513d33d31329d24a662a0084e91af2c77e1165773cb9afc6a6c16a2f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8689bd1b8593dc0c385d7200bd0c11aa7c78c0d72ed219988d79e9b266809359"
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
