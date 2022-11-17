class Hashcat < Formula
  desc "World's fastest and most advanced password recovery utility"
  homepage "https://hashcat.net/hashcat/"
  url "https://hashcat.net/files/hashcat-6.2.6.tar.gz"
  mirror "https://github.com/hashcat/hashcat/archive/v6.2.6.tar.gz"
  sha256 "b25e1077bcf34908cc8f18c1a69a2ec98b047b2cbcf0f51144dcf3ba1e0b7b2a"
  license "MIT"
  version_scheme 1
  head "https://github.com/hashcat/hashcat.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?hashcat[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "3537c38c984f8c0856e18a9c5ec7fd96790d121f71a0ebafd206abe8fc770043"
    sha256 arm64_big_sur:  "d2eba35d2cf35657998adbe73dcda9ce607d9c8d30147736495ff40bba311e35"
    sha256 ventura:        "969126930995386dc28c4a040c6bf742b8331b4a31fb9eef2c15684e9ff74b26"
    sha256 monterey:       "c1f6dc856692c00d1b70e943a11f61e9e25bcaf2187628b2ad9b990d40be7417"
    sha256 big_sur:        "bda8f3382145b5e91dea67605398d55f89c85cf2253975cb918b27432e1b23aa"
    sha256 catalina:       "543c7620bc617933bfc2f2dea6eff0d408b0a6e4c12bd71f213ff7af8b0b434a"
    sha256 x86_64_linux:   "bc09b5c303b00ae131939b048ebd80f63c56213e85e662248205c55779cd286a"
  end

  depends_on "gnu-sed" => :build
  depends_on macos: :high_sierra # Metal implementation requirement
  depends_on "minizip"
  depends_on "xxhash"

  uses_from_macos "zlib"

  on_linux do
    depends_on "opencl-headers" => :build
    depends_on "ocl-icd"
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
