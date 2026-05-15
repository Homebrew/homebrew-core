class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1293_SDK.zip"
  version "12.93"
  sha256 "f2e98c431233421aa0632d8ba929a2d48cdbfe8b78d702a0a226ebad9ed94329"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ab14887f9fbf000502ea79eb3d3a7285198c68a6479d797a898243837e44d040"
    sha256 cellar: :any,                 arm64_sequoia: "11c08a040fe101671772c502d8da0965bd1a0d43160c9b100ddeac41df76617c"
    sha256 cellar: :any,                 arm64_sonoma:  "39f8bc228e06de57550e7ab231a5ad0103c559fad547b633a377f18ff869f1fa"
    sha256 cellar: :any,                 sonoma:        "e0d86744d14cea06f011a18611c1104c7f97e9794e78e131c9d028ad084ea672"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "298b5886d2181e7ef917d5a14e95d97d1592c2af28aef4a9dea850532c28b0ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78f9886b3d35c5987267d50ac1fd70d0c0cbacc29b8327ff52138074fc36bec0"
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
