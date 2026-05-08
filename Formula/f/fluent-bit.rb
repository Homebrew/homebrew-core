class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/refs/tags/v5.0.5.tar.gz"
  sha256 "7bff8842d0b2b24683a10e67a12e336e29f8053edf63fb3d7b6d37323628c158"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "94f91eb73183ff946c703059c71b1bc2544490c6a0cf0183a1442a68433fe959"
    sha256 cellar: :any,                 arm64_sequoia: "7f923d47b560e21fe09b1f6338cb569664e13a92af661ef998d363bda483f17c"
    sha256 cellar: :any,                 arm64_sonoma:  "d2dfa7d99fa0a982cdc6a2f677c43fd1d7cc7ca92b362891893d3e6e5825dd47"
    sha256 cellar: :any,                 sonoma:        "e8b9bb4e4e5b841fc268f5ecb98876aec5c2fa43a17b0e3a364ceb5ac6046a2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75948045035a978f540968829300c39270dfcea7f277b4e0e67a8fa77a2c8849"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4e5bdc6f57de2fc316bf171968af5796e04fc638b54665e6e01d0d15e5f748b"
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
