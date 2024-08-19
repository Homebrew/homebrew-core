class Hashcat < Formula
  desc "World's fastest and most advanced password recovery utility"
  homepage "https://hashcat.net/hashcat/"
  url "https://hashcat.net/files/hashcat-6.2.6.tar.gz"
  mirror "https://github.com/hashcat/hashcat/archive/refs/tags/v6.2.6.tar.gz"
  sha256 "b25e1077bcf34908cc8f18c1a69a2ec98b047b2cbcf0f51144dcf3ba1e0b7b2a"
  license "MIT"
  revision 1
  version_scheme 1
  head "https://github.com/hashcat/hashcat.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?hashcat[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "c9bda2074060ddc2bb25040b8732aa1924e7073b1713167f5ff519bca4e9e59c"
    sha256 arm64_big_sur:  "a38dc13dc95eaffce8765a0a2f28a011b9955ece2554f0979dd98ebfbca65420"
    sha256 sonoma:         "ffd84580339be21088f4e6f088066cda23de53dcd827cb66577703bda2c9138c"
    sha256 ventura:        "93dd43fc9111b38b3328069b3cf743c105d30a384be9eb346e910a43dbbcaef6"
    sha256 monterey:       "ffd4e78e2eee1000b7e96f1c41924fc57ee51f19cc3dc7aeab1d86c8244cca0a"
    sha256 big_sur:        "72c07b363ef009aaf1ca83b6d0bfd3ff7757baee1dd018e5467043ffe15d9638"
    sha256 x86_64_linux:   "3b7abe7959ac081d6cfd3892bf64860f4dbc9657d6711e48cc0fec4445f771cb"
  end

  depends_on "gnu-sed" => :build
  depends_on macos: :high_sierra # Metal implementation requirement
  depends_on "minizip"
  depends_on "xxhash"

  uses_from_macos "zlib"

  on_linux do
    depends_on "opencl-headers" => :build
    depends_on "opencl-icd-loader"
    depends_on "pocl"
  end

  def install
    args = %W[
      CC=#{ENV.cc}
      PREFIX=#{prefix}
      USE_SYSTEM_XXHASH=1
      USE_SYSTEM_OPENCL=1
      USE_SYSTEM_ZLIB=1
      ENABLE_UNRAR=0
    ]
    system "make", *args
    system "make", "install", *args
    bin.install "hashcat" => "hashcat_bin"
    (bin/"hashcat").write_env_script bin/"hashcat_bin", XDG_DATA_HOME: share
  end

  test do
    ENV["XDG_DATA_HOME"] = testpath
    mkdir testpath/"hashcat"
    assert_match "Hash-Mode 0 (MD5)", shell_output("#{bin}/hashcat_bin --benchmark -m 0 -D 1,2 -w 2")
  end
end
