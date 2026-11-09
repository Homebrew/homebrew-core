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
    sha256 cellar: :any, arm64_golden_gate: "58e9df701d22dfcc196c6d81c5e5b56a018ed7d1f913737bad58941bac144fdb"
    sha256 cellar: :any, arm64_tahoe:       "2e7e43b115cfb482b652f7c2bfe2383fd91fde51dd6e48b65fd2045e65b78494"
    sha256 cellar: :any, arm64_sequoia:     "3a737774997226a71794ae552804980a887a905eaae0626ac983ecad6983d54f"
    sha256 cellar: :any, arm64_linux:       "1352a5399b1787aaaca954cf7fe2ab7d98cf17fda57257cbb0f7d936b632b844"
    sha256 cellar: :any, x86_64_linux:      "fce227e49d61c6b5a2fc13c53dad270dca627d5f4fbdbd671f579add1b68434a"
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
