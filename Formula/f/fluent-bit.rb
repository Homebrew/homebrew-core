class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/refs/tags/v4.0.1.tar.gz"
  sha256 "9efbc1ef6fb6d2c63f218c01c6c2323f3e1cdc336b815277a5b0f9f2e1acb052"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bd081eebe2a7ed5e086e5fb585cc734e6e1aff95a61f618fdc86a99e05a82624"
    sha256 cellar: :any,                 arm64_sonoma:  "9b3677a6a540e7a24ae780472a8235faa211ca5db14a05baca9fe373f655ab54"
    sha256 cellar: :any,                 arm64_ventura: "4d130c3f13b1695ff5f0f2d17fc676cb06832469bfcba8ee4a91388bb6ceefd0"
    sha256 cellar: :any,                 sonoma:        "c1ee45cb5d1812791e3046b9f4ecc3681cafd7a85bdd702bd45cc82501dbd0f0"
    sha256 cellar: :any,                 ventura:       "712cd419083865ff11f8c252234d3d3ad1f68e143954fa9f2d89a1cb5fe108e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36fffc48f8fbd3abede1758dc6fc6b8ebbc9245c63c0d9faacbfcbc5ec21420c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc6b3b0223679989ff50653a3f62b51be902b23bfab2f3cc9a64ea7a846759c3"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "pkgconf" => :build

  depends_on "libyaml"
  depends_on "luajit"
  depends_on "openssl@3"
  uses_from_macos "zlib"

  def install
    # Prevent fluent-bit to install files into global init system
    # For more information see https://github.com/fluent/fluent-bit/issues/3393
    inreplace "src/CMakeLists.txt", "if(NOT SYSTEMD_UNITDIR AND IS_DIRECTORY /lib/systemd/system)", "if(False)"
    inreplace "src/CMakeLists.txt", "elseif(IS_DIRECTORY /usr/share/upstart)", "elif(False)"

    args = %w[
      -DFLB_PREFER_SYSTEM_LIB_LUAJIT=ON
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/fluent-bit -V").chomp
    assert_match "Fluent Bit v#{version}", output
  end
end
