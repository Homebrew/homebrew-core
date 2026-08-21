class Mydumper < Formula
  desc "MySQL logical backup tool"
  homepage "https://github.com/mydumper/mydumper"
  url "https://github.com/mydumper/mydumper/archive/refs/tags/v1.0.5-1.tar.gz"
  sha256 "2c2307f1655728b59a6874cf6ccbe85ffea26977fb698eaf62a56976bcf5991f"
  license "GPL-3.0-or-later"
  head "https://github.com/mydumper/mydumper.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(-\d+)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f9a288d5f5d6ca777822dc5f6c127171eaef7331137a120bf3212ebbd075fcad"
    sha256 cellar: :any, arm64_sequoia: "891168ae36cb2b0e8ffa29da4f5f3b87810c2e815aee06a13e9b442d7b1dbd29"
    sha256 cellar: :any, arm64_sonoma:  "66ae6d5602f2769203e2e603f6186958aa27ed1e11ff01cd6e720b214ba9dd33"
    sha256 cellar: :any, sonoma:        "bc84e9452fe1dbf9c638ad335888a25a4c0471ab1957aa071dc0564ee016d14a"
    sha256 cellar: :any, arm64_linux:   "fdade7fba85ea1bd1a264235f390675347c15424f9490a225dfe8b400ef31acb"
    sha256 cellar: :any, x86_64_linux:  "c97999713e242c5633b67212cac78c53389e604d1d10ac7c155fd98d28432f0c"
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
      -DMYSQL_CONFIG_PREFER_PATH=#{formula_opt_bin("mariadb-connector-c")}
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
