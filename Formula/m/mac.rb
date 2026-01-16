class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1200_SDK.zip"
  version "12.00"
  sha256 "d544dd273b6bab7d8e796b7a9f7de2b2e577c880c8156721409ed2b977ff840e"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cb7af69790b98c0ccbb93ab72c79e249e8520b28ba3d20f0220813e88afa7c68"
    sha256 cellar: :any,                 arm64_sequoia: "74cc925b15ee2f24baa32bff8d46569308fda7cc4e77900b368c1fa84dfb572d"
    sha256 cellar: :any,                 arm64_sonoma:  "716b81219adc0a6060d0231e8b995dd80304aa4d807d87996a57fc54844e06b5"
    sha256 cellar: :any,                 sonoma:        "dd492ab89a76622a41231c121e16545f02762351ae4ac1f8905efe7097a08690"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c47d785a4dd12a783e902a75489ce766df853fa700c82ae1e5e41209b96a17b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d73be55ca53d684a6cc8cfc2353f2b4c56136bc65699bed42e0b649dd8d7a16e"
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
