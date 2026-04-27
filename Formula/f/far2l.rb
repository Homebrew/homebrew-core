class Far2l < Formula
  desc "Linux port of FAR Manager v2, TTY version (includes base NetRocks support)"
  homepage "https://github.com/elfmz/far2l"
  url "https://github.com/elfmz/far2l/archive/refs/tags/v_2.8.0.tar.gz"
  sha256 "b0fddad2e3985f245f9e691e23b90fb97f7d29d9a0b131fe686aa3cbb2e4ea01"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?_?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "cmake" => :build
  depends_on "gperf" => :build
  depends_on "m4" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "libarchive"
  depends_on "libnfs"
  depends_on "libssh"
  depends_on "libxml2"
  depends_on "neon"
  depends_on "openssl@3"
  depends_on "uchardet"

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
    assert_match "FAR2L Version:", shell_output("#{bin}/far2l --version")
  end
end
