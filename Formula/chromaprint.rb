class Chromaprint < Formula
  desc "Core component of the AcoustID project (Audio fingerprinting)"
  homepage "https://acoustid.org/chromaprint"
  url "https://github.com/acoustid/chromaprint/releases/download/v1.5.0/chromaprint-1.5.0.tar.gz"
  sha256 "573a5400e635b3823fc2394cfa7a217fbb46e8e50ecebd4a61991451a8af766a"
  license "LGPL-2.1"
  revision 6

  bottle do
    sha256 cellar: :any, big_sur:  "9112d72906e765de84dee2414ec9b21761c7ed4fc357c54e715ed70041add089"
    sha256 cellar: :any, catalina: "955a4681c1937d04e0e7608bc2514c4829b906c43bccf382b8451ad8624a2a77"
    sha256 cellar: :any, mojave:   "1e6727215e5c9e04823b2edb8625ebeec16be87a4b32d7636b35448d2e2ee4d6"
  end

  depends_on "cmake" => :build
  depends_on "ffmpeg"

  def install
    args = %W[
      -DBUILD_TOOLS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    mkdir "build" do
      system "cmake", "..", *args, *std_cmake_args
      system "make", "install"
    end
  end

  test do
    out = shell_output("#{bin}/fpcalc -json -format s16le -rate 44100 -channels 2 -length 10 /dev/zero")
    assert_equal "AQAAO0mUaEkSRZEGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", JSON.parse(out)["fingerprint"]
  end
end
