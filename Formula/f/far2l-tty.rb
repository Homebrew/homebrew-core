class Far2lTty < Formula
  desc "Unix TTY port of FAR Manager v2 (with NetRocks support)"
  homepage "https://github.com/elfmz/far2l"
  url "https://github.com/elfmz/far2l/archive/refs/tags/v_2.8.0.tar.gz"
  sha256 "b0fddad2e3985f245f9e691e23b90fb97f7d29d9a0b131fe686aa3cbb2e4ea01"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url :stable
    regex(/^v?_?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "aafbf3294219de53a3a202fabb4890121a89a470fffbeca77ecb5b27e6ef294d"
    sha256 cellar: :any, arm64_sequoia: "8b3fd615b63e574606a5487cbecfb59b20869fe203d4a6d1831414561699d8ca"
    sha256 cellar: :any, arm64_sonoma:  "869859f8a61f63e52526db8244dc90926f08a5938a9cf892f8f6f95bac39f4db"
    sha256 cellar: :any, sonoma:        "cd59a529ad376e5020b1840e6303694e0abb37c2afd610523dc7af72cf72dde3"
    sha256 cellar: :any, arm64_linux:   "cabbb677711aa18391364086a1bb1b49b0d664444deebb486efe5065908a40e8"
    sha256 cellar: :any, x86_64_linux:  "f302fde41f809c451dd98487ba2407474143503b3fb97bf0c4be8d2a1a7efd40"
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
