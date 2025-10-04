class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/refs/tags/v4.1.0.tar.gz"
  sha256 "2ce0b5d30433f2cde54ce81685ab9a7cfea7851e0c65b3554462df1d7065a45f"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "38c727b84bfd5d45ab87d08cab570d1deaf86a72f01e735102e80fec87ff8d58"
    sha256 cellar: :any,                 arm64_sequoia: "2656fd5119afdf3fb8c601f0f5de9f4c9566a3cf304827f3c2c7d204dd15133b"
    sha256 cellar: :any,                 arm64_sonoma:  "83a78e59c57af0bda3e62564d628a62d32b51201dc7b987613c47e28f829f924"
    sha256 cellar: :any,                 sonoma:        "9103d17e2eddbebc4cdf839edde3a4bd60a535537a208293d0d24d786c67f7a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e102a24893dfaded840c3e07e1d708a27b98314e9d882767fa6e583b122866ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a98e4bab5d39af3d898817418c33401d3787c37314f8df599878e8bd3fd93e3"
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
