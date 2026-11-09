class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://fluentbit.io"
  url "https://github.com/fluent/fluent-bit/archive/refs/tags/v5.2.0.tar.gz"
  sha256 "7f1b92ed09e43c33d8c572bc1643ad0e797f129286468faf85ac56beed6cccad"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7d72d3fbb2332b85c7e27fc7c971d5d097a3fc7501b690b5ca3e6fa2e18c9e4b"
    sha256 cellar: :any, arm64_tahoe:       "95494a274fe83fc6e6082fdd3340d2378c5415a66a35e441e1b11ad5fe3b0f70"
    sha256 cellar: :any, arm64_sequoia:     "4582ed585a2edf0030faa944315c7cc5b44a0962f895b8366e00ace58c1b0938"
    sha256 cellar: :any, arm64_linux:       "05f69990207367f8cc01621d0a4d36014e6561e63998ea550958a9edb1130728"
    sha256 cellar: :any, x86_64_linux:      "9475fd52ce1597a3a21e01e697b14d20fbf6ecfb39dbd55b33817023446d2c4c"
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
