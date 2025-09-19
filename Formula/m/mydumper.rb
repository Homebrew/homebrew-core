class Mydumper < Formula
  desc "MySQL logical backup tool"
  homepage "https://github.com/mydumper/mydumper"
  url "https://github.com/mydumper/mydumper/archive/refs/tags/v0.20.1-1.tar.gz"
  sha256 "8abe5215b4ce159c60439ed4fc709fed3ee03e8ef12ce21666d3c21ce55d81e0"
  license "GPL-3.0-or-later"
  head "https://github.com/mydumper/mydumper.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(-\d+)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4bfc9c0f567bb467e1a9ae52e669d0928c1c90c07aceddc61c7ab805d4ff8025"
    sha256 cellar: :any,                 arm64_sequoia: "586da5be0bdc9d2dbe4843fd560236fe97c5b1dea7c2ece402a1b7f2cfc91d65"
    sha256 cellar: :any,                 arm64_sonoma:  "5d85a241109f2eec02225a0a31938f6a47aeb6541fb5f730827d69fb423d8b96"
    sha256 cellar: :any,                 sonoma:        "35a325c4b5553b27ffb16c300bf14316c10ed44ef12154b2da90cfe731e1e1c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "065ec5d1ea933f5d4443de7a36cbd0652ff20217b5b5b06b0c5ddc3131245829"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98965efe001c9c22de6705b09c0c3bead8672b1ae0e7a46ae68a8e4e9ff04e42"
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
