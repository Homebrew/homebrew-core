class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1202_SDK.zip"
  version "12.02"
  sha256 "ecb6cf51c072f7e1cd6281c8d36449b7364e253862507be5db267f83f57a1af1"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ac70d422fd7bcad176a003e2f02d038d0c6b4ad11b9a53802e81a51f8d4c7c24"
    sha256 cellar: :any,                 arm64_sequoia: "dec030337b751f1bb9d8f7561b63f7b4e6c2a85a5918c59f8b1d12168ca6215f"
    sha256 cellar: :any,                 arm64_sonoma:  "0be77ba8d585e743b45fafe7b9060a70b701a62e36c2cddd430039244eb57208"
    sha256 cellar: :any,                 sonoma:        "321fa28a603f7ae2fe5d418f9bed46728acf07bbc46963030ff9f286bfd0fb30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7631cb19a8ca28eae9da6b33abce488c30e9c580393065e643858330833fee6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c981396c1dfe5aead23c081134c20849e81d207d2ff341db45b5c634efe56f18"
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
