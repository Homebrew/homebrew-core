class Mydumper < Formula
  desc "MySQL logical backup tool"
  homepage "https://github.com/mydumper/mydumper"
  url "https://github.com/mydumper/mydumper/archive/refs/tags/v1.0.3-1.tar.gz"
  sha256 "5ffec51824d758589db788d138804b04e1b8ce51198137be3a0cd2eb855f02a7"
  license "GPL-3.0-or-later"
  head "https://github.com/mydumper/mydumper.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(-\d+)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4ff05b2f370679159d24158134c0fd226303a968ad775ab5a4d7d484ca230bd5"
    sha256 cellar: :any, arm64_sequoia: "5e327a90cad25fbf8ab63d0322f89952e37fac1e41979712c9b3c1a9a7ce2ec8"
    sha256 cellar: :any, arm64_sonoma:  "e94b39dbedd181c73100e90d9cc11cfe9841972df959c351d831be8d83f60046"
    sha256 cellar: :any, sonoma:        "3d18d9a9d29298b47fbf70ea6e4cb60483e726a757cb17d59d5ce9fcfeb51adf"
    sha256 cellar: :any, arm64_linux:   "f4ce9a421765d32e66be5523c3d977bceca9609687ca7bb8260c6ff77cd9aaa4"
    sha256 cellar: :any, x86_64_linux:  "1209c4add0bee04773fc19a1abfb4d6fbfba4b5348d9b0ed6e51ff6c1a1c39c6"
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
