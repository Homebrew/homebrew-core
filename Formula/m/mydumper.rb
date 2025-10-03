class Mydumper < Formula
  desc "MySQL logical backup tool"
  homepage "https://github.com/mydumper/mydumper"
  url "https://github.com/mydumper/mydumper/archive/refs/tags/v0.20.1-2.tar.gz"
  sha256 "b9b703262376ce51706e896537c476c194921aca639f9cafce007992ff9bf7ad"
  license "GPL-3.0-or-later"
  head "https://github.com/mydumper/mydumper.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(-\d+)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a25b2c81c7e912f0cbcfcbd01d25299f8bf6ab82a9efcbd5f9513d5bf280b6bb"
    sha256 cellar: :any,                 arm64_sequoia: "20ced13d9cd1ca47333b142ae9c093e729c0377b4c71790f476e884c05a8b0d5"
    sha256 cellar: :any,                 arm64_sonoma:  "5575c4dad2fff846b588723749aa5d7265978270c64407c0597f41110379b3cb"
    sha256 cellar: :any,                 sonoma:        "a97a69f3c6b8ba20b23ea5d96559f5b0c90637be246cb8f05f7924d2738399a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3a7c19b59dcce09b9d76f4191fb30b2483a305f9810813c141a2c598dce362b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "867c6de5c9e068e8f068e1a408960cac6f51cc4961db7c2f4833352c4098a13f"
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
