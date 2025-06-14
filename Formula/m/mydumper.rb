class Mydumper < Formula
  desc "MySQL logical backup tool"
  homepage "https://github.com/mydumper/mydumper"
  url "https://github.com/mydumper/mydumper/archive/refs/tags/v0.19.3-1.tar.gz"
  sha256 "e78c2b02b33d5d1092c4782e4841bbba5c0531b024b63038524a3ab25606e2fa"
  license "GPL-3.0-or-later"
  head "https://github.com/mydumper/mydumper.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(-\d+)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "12029d778d48d042d0569120f35066ff35d321bafdb4574ee4976a9c7f5d8174"
    sha256 cellar: :any,                 arm64_sonoma:  "ae3ed1c7486bcf76eee921ee7d30975025815fb9b4fee7ba874610c449c5545a"
    sha256 cellar: :any,                 arm64_ventura: "e34ecd329869d62a27bb2a862a0f28a8e2a81a33292015339577fc4a1c2d209e"
    sha256 cellar: :any,                 sonoma:        "3bc1002dcc24a8c184a9b5be18b58b3a493047200864335fc1db4c2b34f49ebb"
    sha256 cellar: :any,                 ventura:       "e9bc164be23ffa468f88b3c8f8c316ba5b3d5d5d05f8084a775a288c800d759b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ac77d4e561b4321e60e1d7abb2abe0252e450f984e431ccf1d7f8ef31e76d50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a954b9706ff7c21606f8fd62d66e989f0f220df804f90820b904ef2d43f36cf"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build
  depends_on "glib"
  depends_on "mariadb-connector-c"
  depends_on "pcre2"

  on_macos do
    depends_on "openssl@3"
  end

  def install
    # Avoid installing config into /etc
    inreplace "CMakeLists.txt", "/etc", etc

    # Override location of mysql-client
    args = %W[
      -DMYSQL_CONFIG_PREFER_PATH=#{Formula["mariadb-connector-c"].opt_bin}
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"mydumper", "--help"
  end
end
