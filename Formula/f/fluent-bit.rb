class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/refs/tags/v5.0.3.tar.gz"
  sha256 "74d5b348a17dffd9550600c59b9887f27638903627fdbfc8ed23878580f57b9b"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1dfd5c34a3b31bab0c6950dedf94428d37c8d02c99416f2ff208fdeb2b694ee5"
    sha256 cellar: :any,                 arm64_sequoia: "91e1a4081ddcff84241379c0cecae5459f975f7dea88de0e84edf5fe467865a9"
    sha256 cellar: :any,                 arm64_sonoma:  "30efd8a87971c638918031685830e21175842e349046d22be3ea507d0d6ab085"
    sha256 cellar: :any,                 sonoma:        "b85e15a72907c22e2190dde4b8d4459fd6e8c57a809035c8f2b1aaa9a1bb9803"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49a2d763b4837cf02b54f80078e4fc15b05aa4246bd05cf4216de89e1a631aaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc2c445ecad715b201e78376cd6da4a8d4dfa839c99783c5c86a9b5839d1fd1f"
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
