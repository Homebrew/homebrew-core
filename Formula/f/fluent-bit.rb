class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/refs/tags/v3.1.9.tar.gz"
  sha256 "ac3a3e235e7f8a92d35f10c99f400f0b0571417a92e3c4caa467073733d42547"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sequoia: "dd1fb712a1217386865d21519c16c660599d62549051577f2fb57e2dfffdfbe6"
    sha256                               arm64_sonoma:  "0e1cccd1a14f65de292d512e3e31d44475a54703f93a57afd3ea049672c18e33"
    sha256                               arm64_ventura: "154253ff91d8bd14aa179b6b29f74d1f77037b0c5bb5fb4c368ac81897580b2b"
    sha256                               sonoma:        "c455f97f48c565c46f9c85377c2ddeb12015e585f6d52a22a73461c0565d8107"
    sha256                               ventura:       "a806afd738b83a74f007aca70d39995cb4e7260dd5692187610160df12714930"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87237dfaaa0011fefe24188ed671b538ee31e199ccea96e740dfb42fd0879f62"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "pkg-config" => :build

  depends_on "libyaml"
  depends_on "luajit"
  depends_on "openssl@3"
  uses_from_macos "zlib"

  def install
    # Prevent fluent-bit to install files into global init system
    # For more information see https://github.com/fluent/fluent-bit/issues/3393
    inreplace "src/CMakeLists.txt", "if(NOT SYSTEMD_UNITDIR AND IS_DIRECTORY /lib/systemd/system)", "if(False)"
    inreplace "src/CMakeLists.txt", "elseif(IS_DIRECTORY /usr/share/upstart)", "elif(False)"

    args = std_cmake_args + %w[
      -DFLB_PREFER_SYSTEM_LIB_LUAJIT=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/fluent-bit -V").chomp
    assert_match "Fluent Bit v#{version}", output
  end
end
