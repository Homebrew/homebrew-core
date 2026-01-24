class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1205_SDK.zip"
  version "12.05"
  sha256 "d296d47195e735b452eabd4dc308dabdb124b28c79df200384ab76cfa42456c2"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "45c54c21bdf13364c3e65cae567c7a29799c855dbe6489d7a8ac150b82ad0e01"
    sha256 cellar: :any,                 arm64_sequoia: "22ca95fa35c8c349ddc4a7b6af8fd1df508a50b8667417cb32b58f0245735368"
    sha256 cellar: :any,                 arm64_sonoma:  "b948d4c6ea412976de45b4b245c02c1318cfaacbb431d9f5e8eb382d4a439141"
    sha256 cellar: :any,                 sonoma:        "5f90d6baf13614e63e110988a940c383f49039ee3284e02ddb194ccd276e2ec3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cc30034ee9cbfe6e700dcff05b27269d35704a636acfc9f21511b3b68d88835"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9a5cb18ab7b6b70ea24d4edb6517b8d89fb73f50b68cce0964b32c7feb7ff85"
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
