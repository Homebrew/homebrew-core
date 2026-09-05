class Far2lTty < Formula
  desc "Unix TTY port of FAR Manager v2 (with NetRocks support)"
  homepage "https://github.com/elfmz/far2l"
  url "https://github.com/elfmz/far2l/archive/refs/tags/v_2.9.0.tar.gz"
  sha256 "69a5218fcfd072a2d4b99ecac8363a67d85f2fd67b65243f8ea7b239bb134ed0"
  license "GPL-2.0-only"
  revision 2

  livecheck do
    url :stable
    regex(/^v?_?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f6db67f588a7ceb26b3ae46e301dfb09a95ae4756693015eebdc249186089c61"
    sha256 cellar: :any, arm64_sequoia: "ada96336c256b5b41f213e06ab6b09c013a40b2adeaba7b955e21f7c40abe195"
    sha256 cellar: :any, arm64_sonoma:  "e57778092b32763bc69386d79b59a285b4e472b75026ff78cf2796dab0009f42"
    sha256 cellar: :any, arm64_linux:   "ae70fa9b270a901576e83cea0d384ddc160e336ab593b6d1382add6851cb2164"
    sha256 cellar: :any, x86_64_linux:  "f7228ed886dcd1aeb18ca44a2e970577656431e9ce1e1ba84f59a76dc71a6e9a"
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
