class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1107_SDK.zip"
  version "11.07"
  sha256 "0cbd12f8b517812b5f2e9a382c64fd847cea2d118ddab8381f2970ac714c78b9"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ad54829960c5fe6bba440b20403eb4c673664faee676838fbc2d1cee641ca494"
    sha256 cellar: :any,                 arm64_sonoma:  "6b29255117580d83c02231e7750319e556dd3d231bf3c6e0bbc5b52efd263350"
    sha256 cellar: :any,                 arm64_ventura: "149e340b9aefde17eb061765c624116452be4ee0e836a0601c182d6bcc01d7a3"
    sha256 cellar: :any,                 sonoma:        "c0152d3c33e6ec5a1a1065fa2e94c5cf7cc606b9c0a2cbe3c3205f0dd1daa3d5"
    sha256 cellar: :any,                 ventura:       "134927bbd466647c6c0f49ff916314d059cb633a9892f535a54ff9ba2b0bc151"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fdf23e643a3cfcfffa60424801188ae91356991f0b868df3728d4234ca38eef6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d54280295833d68517d45fa1ac5622751babc052c2834112635e4bf7658f07b"
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
