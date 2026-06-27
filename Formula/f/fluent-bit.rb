class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://fluentbit.io"
  url "https://github.com/fluent/fluent-bit/archive/refs/tags/v5.0.8.tar.gz"
  sha256 "c67a68ee8ffe5b1ccfdef77ff20af3398103e4d549051a5829a165106c73fab6"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2c22bf362c7668bb35531e8aa5de2e2283e024537eb2fdcaeb9b39096bcab476"
    sha256 cellar: :any, arm64_sequoia: "231b6e4db55a55a632e1016cabe35001ffe07ac09a3b7c028b36a2dde3e5c27b"
    sha256 cellar: :any, arm64_sonoma:  "699c9dc85105985239beaafe9732e0ff9113045d0031ec3385f134a52f0030a7"
    sha256 cellar: :any, sonoma:        "35708eb13ade200fef25016952b87637133e6cb682e56e48a0d0b39c141a14c0"
    sha256 cellar: :any, arm64_linux:   "db8fcb2524dc251b9e6380ff2b4a685362f76dfa1bcefc39294b57d416718dcf"
    sha256 cellar: :any, x86_64_linux:  "339237aa1732d3ec1be846365cf4875619113ddc8e03b2140db0c2fed92fa450"
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
