class Codec2 < Formula
  desc "Open source speech codec"
  homepage "https://www.rowetel.com/?page_id=452"
  # Linked from https://freedv.org/
  url "https://github.com/drowe67/codec2/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "44015b071968d98ee326012c498db6a8308bed1a7a914ecb6d4d8e2a354a4611"
  license "LGPL-2.1-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :git do |tags, regex|
      malformed_tags = ["v1.03"].freeze
      tags.map do |tag|
        next if malformed_tags.include?(tag)

        tag[regex, 1]
      end
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3d0226dbc941097d1554f40399690d89655adc3e4a361e170cb45717e8b4b09d"
    sha256 cellar: :any,                 arm64_monterey: "046221b84ad4d9770b96bcf87c62ea7123d76e32e0cd622d76b068f0fb3d1539"
    sha256 cellar: :any,                 arm64_big_sur:  "d06bc35e4cbfc1418bf6709d1dcf53a092bd39e2e127cf9beeb44225c96f3002"
    sha256 cellar: :any,                 ventura:        "c7b63dae461ae5d78879db06544dd5030f4c6c619da51a16557b1f7b4c11e6b6"
    sha256 cellar: :any,                 monterey:       "de8cbeea525065c01d2e85f0cdb34f25fc6c023ddc7d6cd0dba1df4534a9f3e9"
    sha256 cellar: :any,                 big_sur:        "a24e31b0172897469cd051c74ac57b6a020b63f82e5c58fa9f38695ea05f392a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b34aaf3e12ca3b6dc82f03180ae17bf0e42c40adf2d9052a19380e9b4ec2ca96"
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
