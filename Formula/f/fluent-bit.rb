class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/refs/tags/v3.1.6.tar.gz"
  sha256 "717312873d647fd2848f1834edefb8c6767b6e0eb7ae5b9cc11117d81196d4b1"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sonoma:   "24d34e1b7c38ba9e2f11c2e8f94223b7bab2a61c8d193c8f9308bc225ceb5c61"
    sha256                               arm64_ventura:  "db4029c9359bfbfe95493729cc82e2744952c33b61893bb8ede2beb2de0f87a0"
    sha256                               arm64_monterey: "1a87811319c1f6cb4593b35d3846771d379cce2c6d0a7433b65e8fcf5855f262"
    sha256                               sonoma:         "b771b47772b7da5a3217a4c85c5a408ad3132ccb8a6a8eb207012be12145931a"
    sha256                               ventura:        "6fc404999a3b1cc28353ed423b9feced93b8f7ef989095ee68586cf908eb9e9a"
    sha256                               monterey:       "0c260fec41163c31e20de3e586dcc35b1c789334fc03abb3b388ac0d23b10379"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3f4fd9b2a1ad2c72b6c36fb3330b7747c4ef753a9b7cb3790a55988861e1393"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "pkg-config" => :build

  depends_on "libyaml"
  depends_on "luajit"
  depends_on "openssl@3"
  uses_from_macos "zlib"

  def install
    # Prevent fluent-bit to install files into global init system
    # For more information see https://github.com/fluent/fluent-bit/issues/3393
    inreplace "src/CMakeLists.txt", "if(NOT SYSTEMD_UNITDIR AND IS_DIRECTORY /lib/systemd/system)", "if(False)"
    inreplace "src/CMakeLists.txt", "elseif(IS_DIRECTORY /usr/share/upstart)", "elif(False)"

    args = std_cmake_args + %w[
      -DFLB_PREFER_SYSTEM_LIB_LUAJIT=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/fluent-bit -V").chomp
    assert_match "Fluent Bit v#{version}", output
  end
end
