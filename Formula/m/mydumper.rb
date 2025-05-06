class Mydumper < Formula
  desc "MySQL logical backup tool"
  homepage "https://github.com/mydumper/mydumper"
  url "https://github.com/mydumper/mydumper/archive/refs/tags/v0.19.1-3.tar.gz"
  sha256 "e7feab21b8073a5a7809cf7cc56a08ae0f93313dfe3f6f1fe5c96eec12f09f9d"
  license "GPL-3.0-or-later"
  head "https://github.com/mydumper/mydumper.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(-\d+)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "17b15d765a3b9dd55a58cd299e1b82b318a77872f015bace521bd4c5f9b4007d"
    sha256 cellar: :any,                 arm64_sonoma:  "2e103237038c2913cf0ea2b36c1e3cd0420ed633020e07598755da52c25e4885"
    sha256 cellar: :any,                 arm64_ventura: "2a8a9307520a9fdf50fa6ccfe233fdc1d488b5d218c4472742541b2a3dff4e06"
    sha256 cellar: :any,                 sonoma:        "450d772960aad232b7b639c7c52a254a76c68e85c2bcfacaffc3ec7d80814931"
    sha256 cellar: :any,                 ventura:       "6614ed61e8b36f9e7f02f48d985a2b46053652f92dade60bca559c1acb63f511"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7cdb629423cc0f18ddcf7ef7a0c2eab87970c00d7c4e42f822b9f567b73a4ccf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0318d32774a013eb348768d2a18ad8c6797d5dcfdc14fb0226a6676973176931"
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
