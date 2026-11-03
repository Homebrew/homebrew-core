class Mydumper < Formula
  desc "MySQL logical backup tool"
  homepage "https://github.com/mydumper/mydumper"
  url "https://github.com/mydumper/mydumper/archive/refs/tags/v1.0.15-1.tar.gz"
  sha256 "6a860b0b9b946fa2145ee21e58ea654b80183b7c8a1f3029b8e4830c59613a55"
  license "GPL-3.0-or-later"
  head "https://github.com/mydumper/mydumper.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(-\d+)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b14e6dca6d66683e4a82fcdfaa05c6472ad8a7a8c35f0cf8cb2563c3fc7bf21b"
    sha256 cellar: :any, arm64_tahoe:       "57485ffcb875ae0a55a652fee573563a42984270a024be362187c2221cef8bca"
    sha256 cellar: :any, arm64_sequoia:     "f468534a683b449de621f49a08ca8fc087f50b9887543d1f2689cfa6eb986087"
    sha256 cellar: :any, arm64_linux:       "df8cd974980375678cbbb54c7d8ded2fdd3b765657e5a5e5aa921144dd5fc27a"
    sha256 cellar: :any, x86_64_linux:      "2e2f9180b5853783c8417cbd517d798437d7a8ebe67a563827930eba1d92e92d"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build
  depends_on "glib"
  depends_on "mariadb-connector-c"
  depends_on "pcre2"

  deny_network_access!

  def install
    ENV.append "LDFLAGS", "-Wl,-dead_strip_dylibs" if OS.mac? # avoid openssl linkage

    # Avoid installing config into /etc
    inreplace "CMakeLists.txt", "/etc", etc

    # Override location of mysql-client
    args = %W[
      -DMYSQL_CONFIG_PREFER_PATH=#{formula_opt_bin("mariadb-connector-c")}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "metadata file was not found",
                 shell_output("#{bin}/myloader --directory=#{testpath} 2>&1", 1)
  end
end
