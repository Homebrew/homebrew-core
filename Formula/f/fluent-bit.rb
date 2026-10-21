class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://fluentbit.io"
  url "https://github.com/fluent/fluent-bit/archive/refs/tags/v5.1.4.tar.gz"
  sha256 "cfdb83fe8912529e70421a4302374fd0695808a33b8a47f8dd748a64a3257a58"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "573e92b5df9e3e487ab44292c16f0563011aca85bd9f0dc1a49b8b4f921c0220"
    sha256 cellar: :any, arm64_tahoe:       "ae355fc201d1e2863d9e16ac859985c3d407bf16878d5d44842b5cc63da9fffd"
    sha256 cellar: :any, arm64_sequoia:     "0dc4a586edef326f61a965197d20685b682fef17cccb08480bab71b5a57e5ecb"
    sha256 cellar: :any, arm64_linux:       "370c0b709bb1073e91642298a974853ea62ad11bcab415ec8850f1402521af16"
    sha256 cellar: :any, x86_64_linux:      "7e03bfa177b317bd6a4033054d07b0bf7b5666dbcd67a1ca0465cd1b4bde86f2"
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

  deny_network_access!

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
