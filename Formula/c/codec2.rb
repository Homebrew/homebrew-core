class Codec2 < Formula
  desc "Open source speech codec"
  homepage "https://www.rowetel.com/?page_id=452"
  # Linked from https://freedv.org/
  url "https://github.com/drowe67/codec2/archive/refs/tags/1.2.0.tar.gz"
  sha256 "cbccae52b2c2ecc5d2757e407da567eb681241ff8dadce39d779a7219dbcf449"
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
    sha256 cellar: :any,                 arm64_tahoe:    "efb5e3717cb204bc90d294e0353ed8e610795cd64950a17755eb74add01fcc95"
    sha256 cellar: :any,                 arm64_sequoia:  "c440a292877b0280780fead2695c9693ab407f28189cccf7ffe3f23e9957e2d0"
    sha256 cellar: :any,                 arm64_sonoma:   "ffb282985d9999fa657f2b7975abb94b565728ccb48e35dd91b731f5836bc9fe"
    sha256 cellar: :any,                 arm64_ventura:  "011a69e95c4b665d2d1581d2c357d5cb0eb68c69ff5b6923035d5aeaab50d495"
    sha256 cellar: :any,                 arm64_monterey: "49b0ee03a567601d41a18395e125cd93722d7dfc5431839b2abc55b463c1d509"
    sha256 cellar: :any,                 arm64_big_sur:  "52df3ab6255b2191b5666056a05f058b5cae3a739b18917bd33e1187fcb0916d"
    sha256 cellar: :any,                 sonoma:         "7b47833fb368ab52135288ccc77a4ba01f66a8c92fd396e473be77a151ae2ee4"
    sha256 cellar: :any,                 ventura:        "8731a4ab8dc22a3713b9fdbe5ef39e86fa9cf7b3da039d64806e8332fa9fbed8"
    sha256 cellar: :any,                 monterey:       "f2352930bb0c8ef374521c8137dabc2104b3318560fb6c5fade441766a32d515"
    sha256 cellar: :any,                 big_sur:        "612d1193fd4999926f62174fe2efcccbd695f4e2ef0af50b707c145607a042e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "21f453f1166d76a11abea03a8c8c128234eeb1ba4e87719d0b7b7759f4cf2e86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a63d4e33df59bb6bf81e6db934047a941a95fba6478da884dd7b0a53f418b163"
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
    system bin/"c2enc", "2400", "test.raw", "test.c2"
  end
end
