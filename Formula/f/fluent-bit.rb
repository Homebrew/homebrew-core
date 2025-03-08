class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/refs/tags/v3.2.8.tar.gz"
  sha256 "60af0b45435e211375aa044e8bdd0588e28452872aff320549ef015be33331cf"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "327e62547f63baccedfa1141e2d111036fcba66f2ee8fbf0fd181545a8815389"
    sha256 cellar: :any,                 arm64_sonoma:  "5d1b19f474b985836328928547ed9d5233c51c070257f4c5cdf094c3ecde7cd3"
    sha256 cellar: :any,                 arm64_ventura: "70409cc17c0065b55edfa2b5b337155cc7f40c15f63e13872fa2b1f59c37ae42"
    sha256 cellar: :any,                 sonoma:        "1dbfecb3b7a9ab0384a4f98a824819f2067f53af1d247f49bbed013862eee9bc"
    sha256 cellar: :any,                 ventura:       "0af9d76bea778996c806d0244a79cb1ed56a6825d848af3f7bf9928bae5ad12e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec3703d53a0c8a2fee468aa2c2624a20ea63519942909cefbf96c0fbb8c06ba9"
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
