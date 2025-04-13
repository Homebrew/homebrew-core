class Nemu < Formula
  desc "Ncurses UI for QEMU"
  homepage "https://github.com/nemuTUI/nemu"
  url "https://github.com/nemuTUI/nemu/archive/refs/tags/v3.3.1.tar.gz"
  sha256 "7cdb27cbf5df1957d0f0a258fc334f15d9e2d06a450a982bb796094efc3960c0"
  license "BSD-2-Clause"

  bottle do
    sha256 arm64_sequoia:  "4c96f0430555710f094365598dddb0e2089ab38b1c756532a11f2a3303bd2768"
    sha256 arm64_sonoma:   "af6f110c24124397c439c2b8ffc7dd0b9186fcbfe9946ad0d45a4a3a094146de"
    sha256 arm64_ventura:  "7ee1275f2d0d4420779817a5379e3b5aba1189a2912ccc3bc099c0d149614bf6"
    sha256 arm64_monterey: "d1e08e1f8edafdf159a802c2f37e4413a61c15265f9cc2821b8d538d293a0a93"
    sha256 sonoma:         "4eae6f67f094316ff9ae0aaea3be33254e870a74677b962735c2f78a5bfc7682"
    sha256 ventura:        "f01fb55760affcd6ff698e4b680c3ae12212493b3ed530f75ef626cdba48b82b"
    sha256 monterey:       "5feb7ba4d086208474da5fbf0c1a98ceb26d783bc2950fe3a9ae1d90519a7289"
    sha256 arm64_linux:    "14a133841c2ab6395959d5d2a84b20ea4c585571c7bc9ea3d435efc0a4af4872"
    sha256 x86_64_linux:   "babf6558252a668a49b3fb0552415c50ebabbcee6ba4dad54a64e8f01b8dc79f"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "gettext"
  depends_on "json-c"
  depends_on "libarchive"
  depends_on "ncurses"
  depends_on "openssl@3"

  uses_from_macos "libxml2"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "libusb"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    expected = /^Config file .* is not found.*$/
    assert_match expected, pipe_output("XDG_CONFIG_HOME=#{Dir.home} #{bin}/nemu --list", "n")
  end
end
