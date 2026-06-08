class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/refs/tags/v5.0.7.tar.gz"
  sha256 "a760cdce272d6025100346d27315cc03a9b3466e5a8a24aaae6f2ad6a9cda29f"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f11bf62d4281d5ec3c5fd3f7cb7aafe1e977c674a890152da142c051c613d44c"
    sha256 cellar: :any, arm64_sequoia: "7f1ea69eabdc93c9dbc55a8f0657242eab1744413a58880e60767cf015cb00ff"
    sha256 cellar: :any, arm64_sonoma:  "d233925f55e6fb99a4a08d8a668bcea02616c19c007e79874738bc1eeab9b0d2"
    sha256 cellar: :any, sonoma:        "b194e4543de8eb7a81fa038b976f7c015faa7f5449412aaddeb8be6c0c2ff05c"
    sha256 cellar: :any, arm64_linux:   "02a91ba4941a562e7f9f05fbeee4b8f185e57b4f35dc4a16bfb69cb1ae5a2c41"
    sha256 cellar: :any, x86_64_linux:  "ab1ecb60f170cb239bd68553b39f6390846a7237bb8617bf4860a8b16696740a"
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
