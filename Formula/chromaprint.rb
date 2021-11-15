class Chromaprint < Formula
  desc "Core component of the AcoustID project (Audio fingerprinting)"
  homepage "https://acoustid.org/chromaprint"
  url "https://github.com/acoustid/chromaprint/releases/download/v1.5.0/chromaprint-1.5.0.tar.gz"
  sha256 "573a5400e635b3823fc2394cfa7a217fbb46e8e50ecebd4a61991451a8af766a"
  license "LGPL-2.1"
  revision 6

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "11a79e898ccfdc16613d411903e3bcb4ba8dee2d65d94b253d99a7f1c6c1d18f"
    sha256 cellar: :any,                 arm64_big_sur:  "7bab5925c514da172d5e0be59a8460155adb6e2fc37fe5bb6e5e1f767c2fbd83"
    sha256 cellar: :any,                 monterey:       "678524ca5ece22cdbfee40561f4d4e4fded8c96cd1dd1b8f0cccc625b71f7480"
    sha256 cellar: :any,                 big_sur:        "ec8dfe9d09099386fdea8b6728b2053fef7e9d29b76a488157fb347e93889751"
    sha256 cellar: :any,                 catalina:       "f29e1e551b155aa74c43a6a7d200ccb13841727efba1f304eea914fa1c68b89d"
    sha256 cellar: :any,                 mojave:         "8ed4d7976e0262efe480a6da3456bfb9344aac15119bce2fa594bcc0a828f5e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8ae4ca34ec11a20168dc3ff040144adce01a12f10898e57f7ef8df4b64889fa"
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
