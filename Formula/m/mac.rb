class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1262_SDK.zip"
  version "12.62"
  sha256 "9e15fb5360651ed7f8ea30de538f6ace9a01dd773ebbe887a4ae9fe4b7545f6d"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1fd310eba306022ee798380bf35a540dacd18bba523314de29225805880b8c5e"
    sha256 cellar: :any,                 arm64_sequoia: "0464c7c6b7e1fcd5a329e6b41147df93825e4dba2bd100518eb399e38eaa3717"
    sha256 cellar: :any,                 arm64_sonoma:  "a3c7280403613bb3fc272b2a7c2e7b7b41e2bf8d7f7eb910216bb186da0d1606"
    sha256 cellar: :any,                 sonoma:        "07e932491e8bbf8349f1b768c8cabc87595ddda50102aa5485bf7291baecd7ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14282f288dbc9041d449d359833838e08b21ea5c41b3ff8528576a8e38493edb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "373ef5870c5f91d41ab1e591258333f0b03180e1a4582a44095c5f4e70d3c5a6"
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
