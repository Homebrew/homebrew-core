class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "ef9a479c8cc12e01de6682e0cfd21a0a5d335a0ab9be14bbca37211fbf428cad"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "74c47d1ce2677dd4c383414e66d860c1b4090fbe6c79a07ec2e34ddaecb24d57"
    sha256 cellar: :any,                 arm64_sonoma:  "3b0cb73d2022316af625711758365079fc350ef07fe087da0c4c4d3f1990c1a5"
    sha256 cellar: :any,                 arm64_ventura: "5bbc4aea7c2aa51d472a85aa04239a5b3a34c58b0906a3aaefa13d8605c3dd9b"
    sha256 cellar: :any,                 sonoma:        "fde1e2b5cdb3c5e3e72820b2287ef180caf75fca89eb0c29f6ff1ec1cc5d4da6"
    sha256 cellar: :any,                 ventura:       "852c9196040d453adf66407de1206e06c7ad9b298093603d991fe77a127d1f9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4cbc597cce999207095e78b6aff82a40299231b532b12e4697c127ddd512a91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83e4eb6d683d250ee6b4b70924833656599c6ecd14bc6f4f81bdbae4b9a8e6ae"
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
