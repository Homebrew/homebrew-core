class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/refs/tags/v4.0.9.tar.gz"
  sha256 "0031f74b616b4669064a59902559da2f87174aa8007e749b5df19ed79c534f5b"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "352c3121163607a62a65ca8122479f334299235dc42ee74395281bba5a433cee"
    sha256 cellar: :any,                 arm64_sequoia: "2663aaaded5abcab3ca0cfaf1dcd0dbfe5aa39e6d240ca0c0483265e46d9a42e"
    sha256 cellar: :any,                 arm64_sonoma:  "a6b33222bf0dcc0de0ce0ff06b1ef36f64faea0b1890e77e50160af8037526c1"
    sha256 cellar: :any,                 arm64_ventura: "4653624adf3161eb299e8c37544b81c69a563120610c5fee824464328e523c53"
    sha256 cellar: :any,                 sonoma:        "59466e50b21c82d221465ef306113a43fec3f8d8ea72c53bbc70394bec931401"
    sha256 cellar: :any,                 ventura:       "24b474498559b1a87f52d94ac466ab3c64e8760291f356a0b893f888ede9256c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44ddaa70db03e4637e9fbf36fd11b196685b446cc6930783a5ebbde4fedbfe05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a37b0be04fb996199fad2f3af2d5b890e7873d0226b396cd889a22482b0e1bd6"
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
