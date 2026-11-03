class Mydumper < Formula
  desc "MySQL logical backup tool"
  homepage "https://github.com/mydumper/mydumper"
  url "https://github.com/mydumper/mydumper/archive/refs/tags/v1.0.13-1.tar.gz"
  sha256 "5b9a79e65dd252672b77c0424a479212df9ad71d807a0ea9d82fcb032bcaec5c"
  license "GPL-3.0-or-later"
  head "https://github.com/mydumper/mydumper.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(-\d+)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "462002b6f3ef2b901893d6f528ad1d8d04e8e5c4e62330b1169a0765e2a2b073"
    sha256 cellar: :any, arm64_tahoe:       "9d1c6b7bb5bba9d30346d2b14003f39c2368c682d4d9e5491a9c8d263e922fe5"
    sha256 cellar: :any, arm64_sequoia:     "ae3dab29250db9fd638f2464bca521017fd77e621bb50557dbcab9c10b6db94e"
    sha256 cellar: :any, arm64_linux:       "9f7baf91d5be23499a71ba63f6fbbf48a6b3f889f13616e740530484045ec71c"
    sha256 cellar: :any, x86_64_linux:      "0605bd6eec5610f49c865d892b16dedfc8bbef920ac8a29fd55792685b12fbf6"
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
