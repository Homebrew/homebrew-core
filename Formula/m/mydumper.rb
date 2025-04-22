class Mydumper < Formula
  desc "MySQL logical backup tool"
  homepage "https://github.com/mydumper/mydumper"
  url "https://github.com/mydumper/mydumper/archive/refs/tags/v0.19.1-1.tar.gz"
  sha256 "5431a91befdb767f7620242da45673f699164f7590599b091f023f394802899c"
  license "GPL-3.0-or-later"
  head "https://github.com/mydumper/mydumper.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(-\d+)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8a1253cb85c9a73e6fda0f5c7c9788d54f681456a3b95a77fac470a46dc68792"
    sha256 cellar: :any,                 arm64_sonoma:  "594cfa26b559d4543281ab97a46b978a1df5cee522bf8836163ffeac784b4ad9"
    sha256 cellar: :any,                 arm64_ventura: "f633705ac570e1e42654c8879aee87656508d3311b11b783515fa8cf418ae48c"
    sha256 cellar: :any,                 sonoma:        "b29850daf95b406df979c033caf26e75dada97f6a56fab7e2887fb77984e0f2a"
    sha256 cellar: :any,                 ventura:       "f04bb5ddb566dfe8253c464b7045f56ca982d6869f8bb1c744535ec235ef8023"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f317ddfed59905c5ebe9f16b949283f7cea14f43cc31f646059bfc4baeac4573"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08bb7d698eca02c925c407b5f614b5a93f95bec7b86d15d9fbf71e5308e374d2"
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
