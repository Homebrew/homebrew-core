class Far2lTty < Formula
  desc "Unix TTY port of FAR Manager v2 (with NetRocks support)"
  homepage "https://github.com/elfmz/far2l"
  url "https://github.com/elfmz/far2l/archive/refs/tags/v_2.9.0.tar.gz"
  sha256 "69a5218fcfd072a2d4b99ecac8363a67d85f2fd67b65243f8ea7b239bb134ed0"
  license "GPL-2.0-only"
  revision 4

  livecheck do
    url :stable
    regex(/^v?_?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "575e09a86ae341e6c6d6ef36aa68c9a659193f95d495d74b25e17129589266a6"
    sha256 cellar: :any, arm64_tahoe:       "366ec7187d858a2b04868948dc14a9cc3073cfabb409eb235dd8c0b5d6cadf72"
    sha256 cellar: :any, arm64_sequoia:     "d36ae0b8e8c141ed9c0fb512bc48023d41adaea99ea211915e1362b2e0df3129"
    sha256 cellar: :any, arm64_linux:       "9c38fdd7d9dfc8ab6d4bc910ea8136c813df2e059bb49f6262751d4837d51449"
    sha256 cellar: :any, x86_64_linux:      "a32278654d860f1163af83abeff169a1fdf009f153752273d720cd5bc20c8e8c"
  end

  depends_on "cmake" => :build
  depends_on "gperf" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "libarchive"
  depends_on "libnfs"
  depends_on "libssh"
  depends_on "neon"
  depends_on "openssl@3"
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
