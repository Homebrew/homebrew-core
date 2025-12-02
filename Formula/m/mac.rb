class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1188_SDK.zip"
  version "11.88"
  sha256 "84bbbd6c047dd1dab1b30661de0f005127f8659e21ff80318ad877c5b155f4fb"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "69772f2109f0549b26eea5a03b8f259643e39388b40be4682b1d4b98b572c41c"
    sha256 cellar: :any,                 arm64_sequoia: "b1d39f4b3036336566b89124bcf9592b42c1ec03bc18e5136cf51360b050332b"
    sha256 cellar: :any,                 arm64_sonoma:  "177b8aafce57b5b80450a0d31a4ee9dadf6ffd15c29f1ecdb192331f6d48b149"
    sha256 cellar: :any,                 sonoma:        "96213c0bdf19222df6fae151a42ca8f8f7923e7220092c5e55b7fb6acd2edb77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0cc51cabe40d3c1ac652a8b940a796647c3ff2244cd588637819730870a5ce9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ea0ae95b3db8b70fa0b7166a61864ee7ae8558f877328ee1ca09bac51449579"
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
