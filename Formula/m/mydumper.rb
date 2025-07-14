class Mydumper < Formula
  desc "MySQL logical backup tool"
  homepage "https://github.com/mydumper/mydumper"
  url "https://github.com/mydumper/mydumper/archive/refs/tags/v0.19.3-3.tar.gz"
  sha256 "678ed61d88d354750687610c871ab5fcba668be4274268c9aeafa9b53a8cbb8f"
  license "GPL-3.0-or-later"
  head "https://github.com/mydumper/mydumper.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(-\d+)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9c470dc1fea731799de845187f2fbeffb59c814296689240a5dfb3b7d5756ae1"
    sha256 cellar: :any,                 arm64_sonoma:  "f46ec7f6636a70ec96d8e887cf2d4deb96487c7cf73a31a0bd9fb2988aeb897a"
    sha256 cellar: :any,                 arm64_ventura: "d03984e1c701bf73739f7fff4be327312b69790dcdec8ce11300c2660aea8585"
    sha256 cellar: :any,                 sonoma:        "197f527858dbc06d663646466050c0a58f766ce3f692805ab05f00153b798fec"
    sha256 cellar: :any,                 ventura:       "83ebafd7ed5012c45b32173702ceaaebd226ac633e7c0ba58a93950648d59292"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d9a6314b2a736df5433db2e2c36c2523fa65de46accca4a01f256017b2b49d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "207adef3664276674ee3e777946e3b6d8a2166abe10d67e9da16339354770a13"
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
