class Libvpx < Formula
  desc "VP8/VP9 video codec"
  homepage "https://www.webmproject.org/code/"
  url "https://github.com/webmproject/libvpx/archive/v1.12.0.tar.gz"
  sha256 "f1acc15d0fd0cb431f4bf6eac32d5e932e40ea1186fe78e074254d6d003957bb"
  license "BSD-3-Clause"
  head "https://chromium.googlesource.com/webm/libvpx.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c4582d6d18d184b3d7087dc63d0868861830ba3501828dc51686037dd8b52491"
    sha256 cellar: :any,                 arm64_big_sur:  "ad0ed26552883987edf5a30af668a00212105044d290db0d1177bc526e4ce429"
    sha256 cellar: :any,                 monterey:       "6b091bdf2175b31d57ae699efdf288589c989439dcd7a3abf0311ebdf5029a6d"
    sha256 cellar: :any,                 big_sur:        "1946876cf2681f292207a096d854816b4c874a3895993acab783342d129509b4"
    sha256 cellar: :any,                 catalina:       "925e31b0ac36757562c95eeb2c9c0172f6813ab8670a5a245d966c000dfcb79f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51d009028436923653479737066c8735385e404bf6813e68af9f074fcbbfe4c2"
  end

  depends_on "yasm" => :build

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-examples
      --disable-unit-tests
      --enable-pic
      --enable-shared
      --enable-vp9-highbitdepth
    ]

    if Hardware::CPU.intel?
      ENV.runtime_cpu_detection
      args << "--enable-runtime-cpu-detect"
    end

    mkdir "macbuild" do
      system "../configure", *args
      system "make", "install"
    end
  end

  test do
    system "ar", "-x", "#{lib}/libvpx.a"
  end
end
