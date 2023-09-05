class Chromaprint < Formula
  desc "Core component of the AcoustID project (Audio fingerprinting)"
  homepage "https://acoustid.org/chromaprint"
  url "https://github.com/acoustid/chromaprint/releases/download/v1.5.1/chromaprint-1.5.1.tar.gz"
  sha256 "a1aad8fa3b8b18b78d3755b3767faff9abb67242e01b478ec9a64e190f335e1c"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9df7a9b08cf6557f60d607c26c2fec7644ed9c1ebb0291113930b02e2ca8c33c"
    sha256 cellar: :any,                 arm64_monterey: "d4479962c7c30dbc07c8d4639639198e8de0015f35ce7e3ac47c5e87e492333f"
    sha256 cellar: :any,                 arm64_big_sur:  "8ce15ae4efe13275af05b62e83fbcde65644d7baee3dd4ae37fae7007396b80c"
    sha256 cellar: :any,                 ventura:        "f3457e6b097e705e87d4c54ec7335c59365b7b307830ede26123810ae51eb0ba"
    sha256 cellar: :any,                 monterey:       "86d59168bfd57c19029084ea626953a99976361f4d0aadcdc6d51fbda8b8ca6b"
    sha256 cellar: :any,                 big_sur:        "f9df429a357d408b65f6e1e5effc720005bb75bc10e069891acbba25430b755d"
    sha256 cellar: :any,                 catalina:       "935e7dbb82458a6dd276b3265d8df41390c6aa236cbdf4ef4287662961f5d97d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aecf570ed20d986f95f0071c52c0cca65eb96ef6d308a60d83529b1f16984682"
  end

  depends_on "cmake" => :build
  depends_on "ffmpeg@4"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

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
