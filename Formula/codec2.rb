class Codec2 < Formula
  desc "Open source speech codec"
  homepage "https://www.rowetel.com/?page_id=452"
  # Linked from https://freedv.org/
  url "https://github.com/drowe67/codec2/archive/v1.0.1.tar.gz"
  sha256 "14227963940d79e0ec5af810f37101b30e1c7e8555abd96c56b3c0473abac8ef"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any,                 big_sur:      "c28da7a7d230e8505859eafa28d9238ccadd97c4847f5ee5c269ffa24245ba49"
    sha256 cellar: :any,                 catalina:     "d41040646585e5b91438818ff4dfdccc94b3a2567d31d6960710f8f2455bab04"
    sha256 cellar: :any,                 mojave:       "460c2febeb64e913796ee3f161b8fa50bbc00904c99228d5122324ebadd91fe9"
    sha256 cellar: :any,                 high_sierra:  "5f4530a54adbc38253b993bdbb21da86b4d11725b2edcbec79e43ed739875208"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "eb169319217f165aa027c09ed5591e246db1f357884bd63e26cc86ab0e029814"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build_osx" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,#{rpath}"
      system "make", "install"

      bin.install "demo/c2demo"
      bin.install Dir["src/c2*"]
    end
  end

  test do
    # 8 bytes of raw audio data (silence).
    (testpath/"test.raw").write([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00].pack("C*"))
    system "#{bin}/c2enc", "2400", "test.raw", "test.c2"
  end
end
