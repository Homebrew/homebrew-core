class Mydumper < Formula
  desc "MySQL logical backup tool"
  homepage "https://github.com/mydumper/mydumper"
  url "https://github.com/mydumper/mydumper/archive/refs/tags/v1.0.17-1.tar.gz"
  sha256 "6498cc5dfa3f3e7663ccaee9bdd6bdbe5555588d492838571f160212898f727a"
  license "GPL-3.0-or-later"
  head "https://github.com/mydumper/mydumper.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(-\d+)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6a6dc634e0b5c4f061ac386ce1031e373f1a225755b599a7ecf306b95a81d252"
    sha256 cellar: :any, arm64_tahoe:       "4012676da42e9f4ee6f6837d70156be59078600504d51954f9d1c4828fcb44f4"
    sha256 cellar: :any, arm64_sequoia:     "2b4aa6285780db88965704640b465dc388226dedf8f6353223e1ed0da07205e6"
    sha256 cellar: :any, arm64_linux:       "e6bcbf902fe8b39037bed397942f42c70611a8ce984fa1a6badb4f4587f428a4"
    sha256 cellar: :any, x86_64_linux:      "22c311088723a58a73c4c39bfbb05b0411928fd4674f9cce7d36e38fb66f0994"
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
