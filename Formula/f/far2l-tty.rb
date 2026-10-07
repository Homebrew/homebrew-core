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
    sha256 cellar: :any, arm64_golden_gate: "106c1d74d0d1eab1b3b8e5ed38a6f118686daf079cb7aa9f38ed1e639e9e98ca"
    sha256 cellar: :any, arm64_tahoe:       "68b915ca1488ac87ee794fbf793b089f706c9b2e8c8823c41aa81b1522641c48"
    sha256 cellar: :any, arm64_sequoia:     "426e7d5239ce89d8d472a4162b5953e9c33dfe2a283d69467a144d29b71d429f"
    sha256 cellar: :any, arm64_linux:       "f097833146bb6153bf23712dd32bb7102491786ac018ccc35b3d07c1d8384117"
    sha256 cellar: :any, x86_64_linux:      "3da9e08f412b3ea39a81dcb0054b02334c39e0902d2d4fe624d43b07d6d93ee8"
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
