class Gmic < Formula
  desc "Full-Featured Open-Source Framework for Image Processing"
  homepage "https://gmic.eu/"
  url "https://gmic.eu/files/source/gmic_4.0.4.tar.gz"
  sha256 "5ffa4a17e1ab70d586c1d53e32a438c8279d7b8b88bcb1af62dfabf48173bd10"
  license "CECILL-2.1"
  head "https://github.com/GreycLab/gmic.git", branch: "master"

  livecheck do
    url "https://gmic.eu/download.html"
    regex(/Latest\s+stable:.*?href=.*?gmic[._-]v?(\d+(?:\.\d+)+)\.t/im)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "445af277cc9e191cf9eb07bcebb87e94e3dec66d8cedcd5b2ae4336eb8c1faaf"
    sha256 cellar: :any, arm64_sequoia: "054e8d82ce9227aedfd0f30613d943d20a57b44f2aa2342fca8ef5bc4eb72133"
    sha256 cellar: :any, arm64_sonoma:  "80242b50a575be9c0af57c4e12d7f4e923d895ec38bf262ee343bd42fe4ef28b"
    sha256 cellar: :any, sonoma:        "629bf07074ed115a14797351bd3501c470f6a9253ae14477aa6f25bc2da7b159"
    sha256 cellar: :any, arm64_linux:   "4edfd54690e7d71dd6d29a1f957216cb295bafdff0d7495d39c715bceeb600c0"
    sha256 cellar: :any, x86_64_linux:  "8ad4ec00ee548dfcd4df1c9a1e88582327183a0b3589de357ac0c892c011f401"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "cimg"
  depends_on "fftw"
  depends_on "imath"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openexr"

  uses_from_macos "curl"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "libx11"
    depends_on "zlib-ng-compat"
  end

  def install
    args = %W[
      -DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,#{rpath}
      -DENABLE_DYNAMIC_LINKING=ON
      -DENABLE_FFMPEG=OFF
      -DENABLE_GRAPHICSMAGICK=OFF
      -DUSE_SYSTEM_CIMG=ON
    ]
    args << "-DENABLE_X=OFF" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    %w[test.jpg test.png].each do |file|
      system bin/"gmic", test_fixtures(file)
    end
    system bin/"gmic", "-input", test_fixtures("test.jpg"), "rodilius", "10,4,400,16",
           "smooth", "60,0,1,1,4", "normalize_local", "10,16", "-output", testpath/"test_rodilius.jpg"
    assert_path_exists testpath/"test_rodilius.jpg"
  end
end
