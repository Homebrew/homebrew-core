class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/refs/tags/v4.0.4.tar.gz"
  sha256 "591037d249d9058e69d83e94a47cb507fa423f0c7d4df202229a01da4996407b"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d3f78c7885249f5b9b9709467f69efc9a8e6af287f801c904045fe4c1a26a293"
    sha256 cellar: :any,                 arm64_sonoma:  "651c4d4700883c50181d85e723a551b8950871d09d71f31a83561ec0a38ac4b5"
    sha256 cellar: :any,                 arm64_ventura: "01410e495acc244d67a788c0481732afabea60b31689fdafa1e2cadb9c9ab277"
    sha256 cellar: :any,                 sonoma:        "cdaded4f81953c85c9ab646bcadcffd982ae77c8a6f0f1fad77eab48380b3bf7"
    sha256 cellar: :any,                 ventura:       "9fc4cb7c04e3d08323a20ed828ec222220138898246a48bc8d0523b3369801d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0009f4132a5a4893bd997c8920ca1d36258fd42310767cfc06863bfaa73b7438"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "302c705cc373a70c1ee684b68d206a25974a1f8732bd7d1d9556df7bb459abb6"
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
