class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1341_SDK.zip"
  version "13.41"
  sha256 "aed9bc9f139a3fad14ef4bebdd94f201467215b93d8cbc3b5d80f87a5a7cb783"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c4c90b855782973f5312c024046ee164a515048f9dfeaf9e321f518428eabf01"
    sha256 cellar: :any, arm64_tahoe:       "11f2167510384b01fddf90028f6aafd2356d4fdef438f22d1afcc4060bd0756d"
    sha256 cellar: :any, arm64_sequoia:     "51c5273c8b41845b8dc6ff6a5ca57da93dae57801193ab39754acf0e547a1291"
    sha256 cellar: :any, arm64_linux:       "df9c328d837f5a2e0e4f7152b92a03bbc2024cdb3d58c2cb90eee52ff90ca399"
    sha256 cellar: :any, x86_64_linux:      "acf146eacc8a7fe9b3374082ff6d0068ab266aa69d4d7c246624d137ebf7a7bf"
  end

  depends_on "cmake" => :build

  deny_network_access!

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
