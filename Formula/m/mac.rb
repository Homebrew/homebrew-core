class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1320_SDK.zip"
  version "13.20"
  sha256 "9cdf4f5afff700b859d417d3996b70ed91d59c3bf7b2fb275f5faeeaf9e4e31e"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f999f00133a91887f45663a63973beffcb4250ff01eb3b25d7b0270f18dc62e8"
    sha256 cellar: :any, arm64_sequoia: "cd9aaa817954e9ca85122e6bc09ef0b2eb592ec955e9919461c1884d3fdbf2d9"
    sha256 cellar: :any, arm64_sonoma:  "0e249e37a4157761deec4be9d99a0d5b1e26cadb3f8b7d9bf4d7a183d0690f0b"
    sha256 cellar: :any, sonoma:        "ab875a47f9c2109ddec9f874160d1b2b8cb56a6bbbf2e8c3828c4f9757f79d67"
    sha256 cellar: :any, arm64_linux:   "312b0fbbd39eaf7ce818396c9f051f2f63a7c8e1d1796ec785195594e9c4b6b0"
    sha256 cellar: :any, x86_64_linux:  "e898109893390280108f58aad9e016054aca41afd7e9d4bcb47d4ca562a93681"
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
