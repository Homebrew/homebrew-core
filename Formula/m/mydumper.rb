class Mydumper < Formula
  desc "MySQL logical backup tool"
  homepage "https://github.com/mydumper/mydumper"
  url "https://github.com/mydumper/mydumper/archive/refs/tags/v1.0.11-1.tar.gz"
  sha256 "7de75355e0320506ebc353e110001fb30e61d44c4524ee5f9ca620dcb3474109"
  license "GPL-3.0-or-later"
  head "https://github.com/mydumper/mydumper.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(-\d+)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2fc0fb4054c516815304578d20c19f6f57579f9c2e4b0ee064833f56b9ec28b7"
    sha256 cellar: :any, arm64_tahoe:       "91a4a1b98d93dbe28ab7ef7fc7e68238b359cb057006b41e75ba55632fa593fe"
    sha256 cellar: :any, arm64_sequoia:     "eeb7658ecf04ed69d805dcc4e49533aa3f157d4b36833362c86bec95e115bb22"
    sha256 cellar: :any, arm64_linux:       "2986719edd978e9341e76ae4bc36b1f89e6add4c30f89e8fda887e7c1d87eaaf"
    sha256 cellar: :any, x86_64_linux:      "110eb5970e397d26a3a2bb32d2479c711aeaaeaf0b115d8f87e103d48043e93d"
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
