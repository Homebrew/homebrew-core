class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://fluentbit.io"
  url "https://github.com/fluent/fluent-bit/archive/refs/tags/v5.0.9.tar.gz"
  sha256 "158e86d5fbf605e5aeced06ee94ce41a224b34311627f8f4083d722d1f6d7967"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b33474da3a4da5cff215b1deea6987ce6949a9ca0a2be62c6ae6a18c391483df"
    sha256 cellar: :any, arm64_sequoia: "aaa8fe9640819547996fc1d0250c50606aeaa0a02341a0cfb762ed8bec5615b9"
    sha256 cellar: :any, arm64_sonoma:  "f9a76dbb000c5503ceb8a3787119bce39f871a9c9898112dab25312358f71cdc"
    sha256 cellar: :any, sonoma:        "5001e2bf8bff72db6c1b27354450586cb94eb3eb89bfe83991f9a910fb490802"
    sha256 cellar: :any, arm64_linux:   "50642891b853706f10a0f75952e7bf912280df81d75f7ef497d375938ceabaa0"
    sha256 cellar: :any, x86_64_linux:  "e66f16b2f91a2d6c6d0457a95f29bb1d15305d3028f41fa8d45e5833eb3a7a6b"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "pkgconf" => :build

  depends_on "libyaml"
  depends_on "luajit"
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
