class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/refs/tags/v5.0.2.tar.gz"
  sha256 "3eaa0c1b0f12c37af78b8155fe3e3b3cfe5e88ee447ebf06ba3d39d3ee11fb4b"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "88925c2ab0df6ff5883ba58ae564527c8caae0a47be741d3126d53c474d18d29"
    sha256 cellar: :any,                 arm64_sequoia: "a80031a31f6e1b6491f4a517569105416b0cbe6a3ce970ea25931d9bf1d910c9"
    sha256 cellar: :any,                 arm64_sonoma:  "1d688442faf64aff38db5f202b210858dddbcb42792eab97efb2e7e57d53dae3"
    sha256 cellar: :any,                 sonoma:        "7fad3875958096d22080797a0d0dfa9efd95612194932404bb93063b50d1eb3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91fd7d499eaf092f19dba5429c2102bf96226a1709fcd1a0dc5cd041aaa31753"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efdbbd9d9e782a5cc283dabc180bfe41740f51a8b3c0bd8fc4aff1e8c7abe237"
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
