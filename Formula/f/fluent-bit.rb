class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/refs/tags/v4.2.2.tar.gz"
  sha256 "5d8e642be576985ad8123609c32d5ac44a9d3dad9eafcdc14208622444b5a4f0"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "11c892cb9f9cba5d77c940d4211263c2f18f8b4f84b9b6207459b5aa8af30338"
    sha256 cellar: :any,                 arm64_sequoia: "775c3ac613a54ff3e3d014c0635b200013e2ac5925d700a5b14c03dc472fddc1"
    sha256 cellar: :any,                 arm64_sonoma:  "617be2cc4af319fc54aff605d4b1bddd085efd1ff53599b9f228f9fd048194bc"
    sha256 cellar: :any,                 sonoma:        "08215415572dbf9177d91759901d2965f13ccfa545c4ee7745be3321a6f6b599"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42b58a87a520afc4744e5a062973f71d8de73561a7e278748ee31eacd4027aa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1613a6bab7ff0ca28942b66da551fa62dc265c6d9fed907d169dd61e74e45754"
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
