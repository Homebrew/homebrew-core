class Mydumper < Formula
  desc "MySQL logical backup tool"
  homepage "https://github.com/mydumper/mydumper"
  url "https://github.com/mydumper/mydumper/archive/refs/tags/v0.21.1-1.tar.gz"
  sha256 "5fcfc9ba0c031b090eb1c3a2f018a4ee82364b3441cb355fe1c810767cb071ec"
  license "GPL-3.0-or-later"
  head "https://github.com/mydumper/mydumper.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(-\d+)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "caa5c9f4079fd2947f57d3d4aef87377e00af0a2b438c22f75afbc18163b5b88"
    sha256 cellar: :any,                 arm64_sequoia: "3e1b686fb045d6ac3a857dfea922f557756237bd1dc420e34ad6f5e007ddff75"
    sha256 cellar: :any,                 arm64_sonoma:  "72134bf7137b02de821d5201511251202c4af9953b84eb86a488c885e29b676e"
    sha256 cellar: :any,                 sonoma:        "2644fe40f8c603e5f83d40837f4d810a7be279e722535868ecd41fa9e68ece36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03cceeb8a2eab689a4c86ec66620a28b38545192791eab4cbf83a0a4f5e6b381"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08236524de0f307ff6a8782e0d0252dd04b1c85ed29b553db45ed454dea9e884"
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
