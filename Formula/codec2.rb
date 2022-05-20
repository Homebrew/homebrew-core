class Codec2 < Formula
  desc "Open source speech codec"
  homepage "https://www.rowetel.com/?page_id=452"
  # Linked from https://freedv.org/
  url "https://github.com/drowe67/codec2/archive/v1.03.tar.gz"
  version "1.0.3"
  sha256 "d1b156035b806fd89a29371a5ab0eefca3ccecfeff303dac0672c59d5c0c1235"
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
    sha256 cellar: :any,                 arm64_monterey: "090856f39e5957c5d3badc83d370aa70bb89d1d5cc6120446d6c3b877581d94d"
    sha256 cellar: :any,                 arm64_big_sur:  "ae72433df0f211abb44fa154af2f7d404a56202a4caec2b5716816e8d69471e3"
    sha256 cellar: :any,                 monterey:       "c4260dad2bfca1133bc167c632602c685abcd3372cd3a2f2c02d913a2ee0c6a6"
    sha256 cellar: :any,                 big_sur:        "68afdf2fe3058e49234d468fe4e17508815d799cdff6883b29debb233690c5d2"
    sha256 cellar: :any,                 catalina:       "9bb3ae4a8ae3c08d24e6a2b0d6823f8e3cc88edb4ac556c91ef1474b6f00c894"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b34f238df3fca8b0446be087f81f1e5e10528a0efcda57e6fee97a78b2210259"
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
