class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://fluentbit.io"
  url "https://github.com/fluent/fluent-bit/archive/refs/tags/v5.1.1.tar.gz"
  sha256 "bbc05936d6981575520596f151978146beb8119c7ab720efd3e3275cc54c13b1"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "75b74e816119eec5ddf080738c6fd24b5fa6718476ba0989a1290239eb40b0f5"
    sha256 cellar: :any, arm64_sequoia: "a87f060445b70e7a54d6992abf4303aacae561b00121d4c67d9b4c1fc9316463"
    sha256 cellar: :any, arm64_sonoma:  "ff211d9e437addeef3587395d4bf14777a5afaf4afc9ff0b0ccaa4629f25be0b"
    sha256 cellar: :any, sonoma:        "9f29fe33ceeb5ef9f6b5cd9e351adf67ad903d7423d7626d497d8eb9ae3f5bd8"
    sha256 cellar: :any, arm64_linux:   "3dc665b5a9104ddc7da093951064c077e71b1de70357ef13dfa96415eeebf42d"
    sha256 cellar: :any, x86_64_linux:  "9e0a7a8f1a68b33ad8e6fe1003cbb3e684519698bbf0463dbb3806bae58fc7f3"
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
