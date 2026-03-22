class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/refs/tags/v4.2.3.tar.gz"
  sha256 "b2dae50fb7a00bbab5eb6d47f3bfc4d56c698d72d485d748cb326bfeaa7249fa"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3d12b053b24178b5826f0fe6e7e03fe6a69f08e708430bfd68ca1df0d7b2748b"
    sha256 cellar: :any,                 arm64_sequoia: "12a055212b801c2769c6ea96a16e96045fb506ed97796033072cf07ca88a1116"
    sha256 cellar: :any,                 arm64_sonoma:  "6687d7e607e4a4ffeacf02a2caf4151f1442d6e80af5891d484b6291b05923b2"
    sha256 cellar: :any,                 sonoma:        "e45e3707238df9eb432437dee266180629eefb132323800a527e70223dbdfd04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a7432aca2ef9869eca928a76c884f9b842b5860e6d75f8050151be2f2a899ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e6f807c6e160d1015e5a0db3db88bbb2ab200ac0fa8d5f13b47b6b0ea71628d"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "pkgconf" => :build

  depends_on "libyaml"
  depends_on "luajit"
  depends_on "openssl@3"

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
