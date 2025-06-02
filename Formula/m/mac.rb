class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1115_SDK.zip"
  version "11.15"
  sha256 "e56db6c7713ef4f26619cf1c368fc2c000a678816ba6bb7773b14d9931d03ac4"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "19c9b278dbc86be9ef70c55cff123b953f081adba5b27a2a055fefb571a5cac6"
    sha256 cellar: :any,                 arm64_sonoma:  "cdfca9fbfafe059ccd82927d7066d557dda82e658c653a33a632cb3413fb64b3"
    sha256 cellar: :any,                 arm64_ventura: "638ef7abfce1c3676e55b3c7c3238a0b12093a4bd5d2006daa38f2a2d431837a"
    sha256 cellar: :any,                 sonoma:        "2f682c17bc1399693ddea152e00350bbec81fb5898d74f2e5146672a7f11b2c1"
    sha256 cellar: :any,                 ventura:       "d90d637545b05cdf548d315af75857541c4dcc568682440f2ec065a04ad4597f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "922d8be2ed4b7f534a3f0889b9f7d47222100963e439cc965ad71b08565ae83f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f18e515038c53b9b8a46c5cad4229a5b93c878ec1083bb865872bdc922ed4ed1"
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
