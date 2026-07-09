class Far2lTty < Formula
  desc "Unix TTY port of FAR Manager v2 (with NetRocks support)"
  homepage "https://github.com/elfmz/far2l"
  url "https://github.com/elfmz/far2l/archive/refs/tags/v_2.8.0.tar.gz"
  sha256 "b0fddad2e3985f245f9e691e23b90fb97f7d29d9a0b131fe686aa3cbb2e4ea01"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?_?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "088121534bab64a1ea3b5ae24d599b48554637c99581a04cf55cf3ee21180709"
    sha256 cellar: :any,                 arm64_sequoia: "37bde471941fb73555cfd74a507817877a4747c23c87a6010a982625cd3751a5"
    sha256 cellar: :any,                 arm64_sonoma:  "856e7218a5a8fe807b9d248402495f41f9a3d2b30084fe4d0e4705473915ca6b"
    sha256 cellar: :any,                 sonoma:        "49ab5d7fc482aa75baaee02257c1a6c07fc1b5dfbd3e6cb435eaf51de5098b08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a15d72ba2c10c49b9ff09893495ed73b8f4c4a64ab803359bc819646eddb2a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "869a9e42952ddf4293495d448202df7a88bda9b91e6676981c9051b827c29e8f"
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
