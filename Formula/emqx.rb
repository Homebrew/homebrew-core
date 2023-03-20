class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https://www.emqx.io/"
  url "https://github.com/emqx/emqx/archive/refs/tags/v5.0.20.tar.gz"
  sha256 "c51dc52d53e812be7d08106dca94236ed58381ff6162f995b029f8d0b01e158a"
  license "Apache-2.0"
  head "https://github.com/emqx/emqx.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8a2ac86b5515731e5a5c68c2a2ebc07367beafd9752c2714c8227f4458359895"
    sha256 cellar: :any,                 arm64_monterey: "331c66d2bd0217ef698eb2071c07a46e78d178c8de2494906a883960d0e59e07"
    sha256 cellar: :any,                 arm64_big_sur:  "3d6a1cf37c5c1ab7875980b032cfb9cecff7b8e6fe9be23b59f6d8255cec6f60"
    sha256 cellar: :any,                 ventura:        "92fa4c6d9761dc8ba9f537d8cb6ad6bd82f33f9264f8944414d929d4c16f20e9"
    sha256 cellar: :any,                 monterey:       "ad87e08801eda98860f048ff4d60c14f2273321bd0ff3c0c8c08e97250359dac"
    sha256 cellar: :any,                 big_sur:        "6c101cace5c730e75df91c3fb8d0a81ca907b1d6b382e7cbff02944e4e52ca98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12bdc40d5c5d08f3c5bea2b3bbd8952200842850b1279dd71eef9771bea4bd55"
  end

  depends_on "autoconf"  => :build
  depends_on "automake"  => :build
  depends_on "ccache"    => :build
  depends_on "cmake"     => :build
  depends_on "coreutils" => :build
  depends_on "erlang"    => :build
  depends_on "freetds"   => :build
  depends_on "libtool"   => :build
  depends_on "openssl@1.1"

  uses_from_macos "curl"  => :build
  uses_from_macos "unzip" => :build
  uses_from_macos "zip"   => :build

  on_linux do
    depends_on "ncurses"
    depends_on "zlib"
  end

  def install
    ENV["PKG_VSN"] = version.to_s
    touch(".prepare")
    system "make", "emqx"
    system "tar", "xzf", "_build/emqx/rel/emqx/emqx-#{version}.tar.gz", "-C", prefix
    %w[emqx.cmd emqx_ctl.cmd no_dot_erlang.boot].each do |f|
      rm bin/f
    end
    chmod "+x", prefix/"releases/#{version}/no_dot_erlang.boot"
    bin.install_symlink prefix/"releases/#{version}/no_dot_erlang.boot"
  end

  test do
    exec "ln", "-s", testpath, "data"
    exec bin/"emqx", "start"
    system bin/"emqx_ctl", "status"
    system bin/"emqx", "stop"
  end
end
