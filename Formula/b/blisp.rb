class Blisp < Formula
  desc "ISP tool & library for Bouffalo Labs RISC-V Microcontrollers and SoCs"
  homepage "https://github.com/pine64/blisp"
  url "https://github.com/pine64/blisp/archive/refs/tags/v0.0.5.tar.gz"
  sha256 "79f87fbbb66f1d9ddf250cdc15dc16638d95e0905665003b08920a4b1fda9f96"
  license "MIT"
  head "https://github.com/pine64/blisp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6848a685d16c4a25a770a11a1059474540579f47a0af7b87bd0a907c3fc70275"
    sha256 cellar: :any,                 arm64_sequoia: "ff28997c11bce2736f54cdb6e31fae1ef5ba7637443203d29ce8b7b5d947cfce"
    sha256 cellar: :any,                 arm64_sonoma:  "b034d4d4510b4d817547caf94730a1a6262608759849ea5782c957b4e8bc157a"
    sha256 cellar: :any,                 arm64_ventura: "8429a988fc4858c21db8bbb87150e1aad7d1d11a306d4a90566c831f3b9b3dcc"
    sha256 cellar: :any,                 sonoma:        "67b1c5420ba76d82760abab0fafa97b343aeba0331a086ab755262f5165c3b1f"
    sha256 cellar: :any,                 ventura:       "185fa7b68d7301e70936fb7b0740a9e672ba89ff9fe51780febd8ebffd33247b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "473ecf51999b00ebacaaa0950602ccd9fa544fbabc13c2a912e4a9b5475b6a52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec80b8a1aa1b9271d6600f34e3d1e7de3ce029d7a87e232787d3e5f7e9405496"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "argtable3"
  depends_on "libserialport"

  def install
    args = %w[
      -DBLISP_USE_SYSTEM_LIBRARIES=ON
      -DBLISP_BUILD_CLI=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # workaround for fixing the header installations,
    # should be fixed with a new release, https://github.com/pine64/blisp/issues/67
    include.install Dir[lib/"blisp*.h"]
  end

  test do
    output = shell_output("#{bin}/blisp write -c bl70x --reset Pinecilv2_EN.bin 2>&1", 11)
    assert_match "Input firmware not found: Pinecilv2_EN.bin", output

    assert_match version.to_s, shell_output("#{bin}/blisp --version")
  end
end
