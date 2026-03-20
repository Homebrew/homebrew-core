class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1257_SDK.zip"
  version "12.57"
  sha256 "15a0a22d3af08a62b7cd3903622d7eb8e6289fc66dd7e54fcd9e17330c95fcc2"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "91af99479ca596acd3a20a848014b55d5ad9664f51990d54e81ec2dddd081582"
    sha256 cellar: :any,                 arm64_sequoia: "c1fcdd6bf1b5959fd1941836d9c3c7d86918c7c4cc41fbf46140f1ed37a302bc"
    sha256 cellar: :any,                 arm64_sonoma:  "2df062455b264fdbca59449f7476ef0caaa2cad506f7b9497584ce974d266ecf"
    sha256 cellar: :any,                 sonoma:        "aad7631dcf9fd37df273f1da67b7b7398565a8d2605c3c3185ea060218d5d54b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f72a8775233880292ca9f95e323e93e642a4709534c2012ba586884eb0b2ed53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7f8871b3db4a01f65d94cded73194b161121c04afea474811ae1cc31f9e046f"
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
