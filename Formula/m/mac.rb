class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1347_SDK.zip"
  version "13.47"
  sha256 "6aec852ecf38ef91c0b323b83356f16cc6d485f1cc7a338151e60995a87e8166"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7a830a08229a0cdcf6743767de243d357db05e597d964b1b7e4878bc1a043898"
    sha256 cellar: :any, arm64_tahoe:       "351420cd664644664fe67888b52cf9fbe9efeb544b7906ab06a731298d0172f2"
    sha256 cellar: :any, arm64_sequoia:     "7b7e5299c4584a79bd8030e2c3b6f5db49250bca7d6e819fff6dd82d667455ed"
    sha256 cellar: :any, arm64_linux:       "bad06b0e38f410c9d3d79409e08899a03b82b3eb0ae217484a72e50b54f42b86"
    sha256 cellar: :any, x86_64_linux:      "35677d20e0d249775c8c6c50a97c00c1fdbaf3b220c5d58c69064bba4a43cfc6"
  end

  depends_on "cmake" => :build

  deny_network_access!

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
