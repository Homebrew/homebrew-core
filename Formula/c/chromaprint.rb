class Chromaprint < Formula
  desc "Core component of the AcoustID project (Audio fingerprinting)"
  homepage "https://acoustid.org/chromaprint"
  url "https://github.com/acoustid/chromaprint/releases/download/v1.6.0/chromaprint-1.6.0.tar.gz"
  sha256 "9d33482e56a1389a37a0d6742c376139fa43e3b8a63d29003222b93db2cb40da"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4dc6986a45afaf618fee24fad316ea1380dd32ee8c682f0d6486cbe7c4178a29"
    sha256 cellar: :any,                 arm64_sequoia: "6830a8d152f94b3e23993d6dd85e1edefc1ededcc4af3e98a089b61fe71b1342"
    sha256 cellar: :any,                 arm64_sonoma:  "ed56a1cf3fc3d3748c593fc9e38d783b8299023000d3197526443410519141b3"
    sha256 cellar: :any,                 arm64_ventura: "55c4b88f06efd67cfe9f17948f10266ed4ce565bcfdbcb18e5610bd6f31f6978"
    sha256 cellar: :any,                 sonoma:        "4df5e7cfb646cbc99f90997aefa13232f3531739d76fa4e985cdb09addba8a30"
    sha256 cellar: :any,                 ventura:       "80d91f255c8ccc0bda1d0d60c3064ce6aa03962dcbf8bf9546b58abd3dd8d75f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f10d33931b5924245417ef9c879ce51712326b150bf839da05b1d8eb8560f9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1ca1441154c133e79dd7bc470b21978df7882ccd8949c33ff1fb0d2f38eea72"
  end

  depends_on "cmake" => :build
  depends_on "ffmpeg"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_TOOLS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    out = shell_output("#{bin}/fpcalc -json -format s16le -rate 44100 -channels 2 -length 10 /dev/zero")
    assert_equal "AQAAO0mUaEkSRZEGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", JSON.parse(out)["fingerprint"]
  end
end
