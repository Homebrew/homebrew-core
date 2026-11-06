class Mydumper < Formula
  desc "MySQL logical backup tool"
  homepage "https://github.com/mydumper/mydumper"
  url "https://github.com/mydumper/mydumper/archive/refs/tags/v1.0.19-1.tar.gz"
  sha256 "03c2db71c62af5db4b12ee0c50b43b841c45efab36c8f1073f6d0d0c92d9bcad"
  license "GPL-3.0-or-later"
  head "https://github.com/mydumper/mydumper.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(-\d+)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "233af161a27e9117aa45375db2e16870ae6f7187abb85230b86c7e50b9aeaae2"
    sha256 cellar: :any, arm64_tahoe:       "3e8448d791f07c24f3bdd8077532f85e9d5fee1bcb39ee73dfb498dacfdb56ce"
    sha256 cellar: :any, arm64_sequoia:     "7e0c50087579b76b96bf4f7c6e6f61dd6900da199cdea709f1c00da58efa84dd"
    sha256 cellar: :any, arm64_linux:       "7691149b7085d6cae4167e22d3c94631fadae7e9a9a34396180ba57bcea4e24b"
    sha256 cellar: :any, x86_64_linux:      "9ca01016b6cc557b2e050e1bc6da3ae18fcda85b6c8af3ef297d2473d11b7262"
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
