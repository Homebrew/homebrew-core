class Codec2 < Formula
  desc "Open source speech codec"
  homepage "https://www.rowetel.com/?page_id=452"
  # Linked from https://freedv.org/
  url "https://github.com/drowe67/codec2/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "d56ba661008a780b823d576a5a2742c94d0b0507574643a7d4f54c76134826a3"
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
    sha256 cellar: :any,                 arm64_ventura:  "02d4522b90c874aad3d55af2efd968359005209c903104265855bd59f0b06b4c"
    sha256 cellar: :any,                 arm64_monterey: "45be98845a1daa7ca5e7a9626efadec9e2eb45e9c829fce7f922c401923fcace"
    sha256 cellar: :any,                 arm64_big_sur:  "868538ca5662c5248d4c1db617afd22474f9895fc8b87dc47dc6f48ee40aaa01"
    sha256 cellar: :any,                 ventura:        "b5b097c1c53685f38ef77cfa3d64846bd6920b0bf37ff36d96c5a1d50f70ae73"
    sha256 cellar: :any,                 monterey:       "ccecd90ae6dfeefa887bad6536dc88fc917490b527d877267a3aff685911f19c"
    sha256 cellar: :any,                 big_sur:        "f2ce7a60268a3402b82ac09453dd91c83c0f93fb9c6022f9678dddd2f4e167fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "debecd75054aaade3720afb552f848862b9e78e967364fa877aa3a6d56ad9d08"
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
