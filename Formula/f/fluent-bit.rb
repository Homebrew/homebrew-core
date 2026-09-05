class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://fluentbit.io"
  url "https://github.com/fluent/fluent-bit/archive/refs/tags/v5.1.2.tar.gz"
  sha256 "1971d86c7dc0f3e6b906890297635d6a3a84e5e7ad64d36521b74da202fda62f"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c73139a1cb951794adae3e4c57b83825d9571fb137cf070d5f8d6865ca1d5102"
    sha256 cellar: :any, arm64_sequoia: "dd43667442dbc34139a463be4539dba38341566b2c6c988c952927d5c4c64d70"
    sha256 cellar: :any, arm64_sonoma:  "26858973292d11b376ba9e04e61fee192d20a6d1549d75f7e1b46f5da6f1ae90"
    sha256 cellar: :any, arm64_linux:   "c6223437af2368483ef2ec84de51cd08b2833ae841f7275d2121bb70bf3cbeb9"
    sha256 cellar: :any, x86_64_linux:  "37511946520c71fa303417c8c93b44caca78b66134a2560b5613e4786fb28ce2"
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
