class Far2lTty < Formula
  desc "Unix TTY port of FAR Manager v2 (with NetRocks support)"
  homepage "https://github.com/elfmz/far2l"
  url "https://github.com/elfmz/far2l/archive/refs/tags/v_2.9.1.tar.gz"
  sha256 "a28d647f12b17fce3a89e939ce036fe4ef0d4fb1a9fc7c44fe27d292021522e4"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url :stable
    regex(/^v?_?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "cfdc3bd2b41791a333a069508ce22391647439190fe728d360f8545b2798e4c3"
    sha256 cellar: :any, arm64_tahoe:       "010a4560c73c26662eb6c518a46117d04849a640bd9a8fc8439cfa7b1b75458f"
    sha256 cellar: :any, arm64_sequoia:     "72762b902c45a7544580275e38ae9335b56583066d877e827f0309ffce5589e0"
    sha256 cellar: :any, arm64_linux:       "10ded4e0e8b165b3ce5f32d3124ec8b7e7d0a20b9ab7425120858c7c18e2334c"
    sha256 cellar: :any, x86_64_linux:      "099ea7de7ad78ccdf53f0758b5033400d2c0db7be670562b8f93b25755c6f429"
  end

  depends_on "cmake" => :build
  depends_on "gperf" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "libarchive"
  depends_on "libnfs"
  depends_on "libssh"
  depends_on "neon"
  depends_on "openssl@4"
  depends_on "uchardet"

  uses_from_macos "m4" => :build
  uses_from_macos "libxml2"

  def install
    args = %w[
      -DUSEWX=OFF
      -DUSESDL=OFF
      -DTTYX=OFF
      -DNETROCKS=ON
      -DNR_AWS=OFF
      -DNR_SMB=OFF
      -DMULTIARC=ON
      -DPYTHON=OFF
      -DCOLORER=ON
    ]

    system "cmake", "-S", ".", "-B", "build", "-GNinja", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # This is a TUI application, better tests are not possible
    assert_match version.to_s, shell_output("#{bin}/far2l --version")
    assert_match(/tty/i, shell_output("#{bin}/far2l -h 2>&1"))
  end
end
