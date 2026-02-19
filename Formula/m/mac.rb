class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1223_SDK.zip"
  version "12.23"
  sha256 "86903b242bbb82b7c5e34783a614f764e1f07d2b9b1e596adaa0a87a794e8108"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "96a1bd7afc99d29eece6faae86ddd8ef8e7a7bcc9fad4fd2510d5d2dad2ab4b6"
    sha256 cellar: :any,                 arm64_sequoia: "33d9e7ec793fdba54ff13bf3641b2c6c0aba495c869b0e10443f9833fc3a9d9e"
    sha256 cellar: :any,                 arm64_sonoma:  "7f0887dc7d520f242c8dffbb3c329bbe6521f046d84850cb2dbd55ab450dfb25"
    sha256 cellar: :any,                 sonoma:        "8618a17e25b262cb7ef3aa584ae62a867b5bea47b1be35f65c67ae266fb5c0cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e94f6c957ec8e4fc2b61f1fb39460296c2cb8a4c137cd2d590822215f506db8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0504d70e2a6d32fa6d52fc268558fb7c1611b6e28b3cc72db07aed97441a651"
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
