class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1303_SDK.zip"
  version "13.03"
  sha256 "b99cf4fa73d16b388e376fba471b02c791c1b8a84031a199ffbe3a5a684dfeeb"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "df0008a602ebd0258cc057d8e4aecd6c47d47f49092ff032c9bd0f035fe05b3d"
    sha256 cellar: :any, arm64_sequoia: "8690198c929cac35d7677f9696890aa8d4ee7dbc388e68cd9c76a497609750c3"
    sha256 cellar: :any, arm64_sonoma:  "22eb890269ad9932de26100663aa605321ac221d43769a1336399f40750472c6"
    sha256 cellar: :any, sonoma:        "6a4bff48fb084a272e13c511ba6c79bf507ad2be44278ac62c2f51c62db7bb87"
    sha256 cellar: :any, arm64_linux:   "0d4fa9eaebdd78fcae82768d57b19db06f123028ddaa50f3c902b8c73a2ca703"
    sha256 cellar: :any, x86_64_linux:  "33786d80b15b4245a33ce030e6ee98a69b15a24fb234379d8fa0d175da590953"
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
