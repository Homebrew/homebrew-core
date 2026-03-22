class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1260_SDK.zip"
  version "12.60"
  sha256 "0bdbc0abbb2663b7911eb04a566351335ed76dabeae8156af40d264ebbb2e0d6"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "131e01ac373d83e6cf82689a56a8678486223e67823835de5e49c5365d13355a"
    sha256 cellar: :any,                 arm64_sequoia: "012be7eb58e7e067155d825929077bc59348d40dd0897baa97706596d8a1343f"
    sha256 cellar: :any,                 arm64_sonoma:  "fc6cce595c5f304c1d448e5f40ec56989852607002484e8dd1cfd70b9f0ba415"
    sha256 cellar: :any,                 sonoma:        "9001b53b7747455b61992171d1faea23815ca9d8cf81c056952e28644b2f5a31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b70074dffc315bbf8507fee44ee271ebf473c7c20a7a5b8e4f54a9638a9ed5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50af0123236325be0126bb85398b0e3498e37952edc8a1bcbfd14687ed2d6a0f"
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
