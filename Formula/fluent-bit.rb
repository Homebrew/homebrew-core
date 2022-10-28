class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v2.0.2.tar.gz"
  sha256 "d04096118f93a68348ea09749c71709b1a7f68817bdfa4a31aa82656998623d1"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_monterey: "4747dec4680e3f1c1589e378152fb95818873297c037867d01873874c7c9eba7"
    sha256 arm64_big_sur:  "bf7312e37bfd3f061dde12a5cb22abe9976c91b51f1e42e079490c6a4bb63566"
    sha256 monterey:       "c92c4e95a8302e78275e1df7aa357b59444974394a0d666b4c6661f31aaa3dcd"
    sha256 big_sur:        "40c4941c3453cc54b2d477a77a7e1bf2b340e731de96401124a2deb63592d749"
    sha256 catalina:       "0a4c777fbbec7f4ddc6c4ca66e42d654262ee65f647e778c99cee8aab3f52e8c"
    sha256 x86_64_linux:   "184a07d888cfc4095c20558e358170b37c200c5a1901d20ead46c56da24cd220"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "pkg-config" => :build

  depends_on "libyaml"
  depends_on "openssl@3"

  def install
    # Prevent fluent-bit to install files into global init system
    #
    # For more information see https://github.com/fluent/fluent-bit/issues/3393
    inreplace "src/CMakeLists.txt", "if(IS_DIRECTORY /lib/systemd/system)", "if(False)"
    inreplace "src/CMakeLists.txt", "elseif(IS_DIRECTORY /usr/share/upstart)", "elif(False)"

    # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
    # is not set then it's forced to 10.4, which breaks compile on Mojave.
    # fluent-bit builds against a vendored Luajit.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/fluent-bit -V").chomp
    assert_match "Fluent Bit v#{version}", output
  end
end
