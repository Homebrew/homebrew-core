class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https://www.emqx.io/"
  url "https://github.com/emqx/emqx/archive/refs/tags/v5.1.0.tar.gz"
  sha256 "49d517e0cfcaab1ed27931fb0b32fdf1e6d087cd48df3eb3fb512b8570af6234"
  license "Apache-2.0"
  revision 1
  head "https://github.com/emqx/emqx.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "101e34ff7b16677eb4e123da363e1d8d7f5d8edae6f30d018f4eeb3bf7dfd812"
    sha256 cellar: :any,                 arm64_monterey: "c76d110280fb4932f839b06fbb4a58f5df7748c691be73ad50a651e56a276040"
    sha256 cellar: :any,                 arm64_big_sur:  "5b9b0102f3e6538e2ff0a3d8cbfbef3de728591399793d89fc488807c34bb1b2"
    sha256 cellar: :any,                 ventura:        "c30543c831aaea671d0c6c6d37cddab47387aba0968312a9d091c07141277d11"
    sha256 cellar: :any,                 monterey:       "c886ab3696b4e3a7e047cabe95982a9365939e4ab40f1f23f2f0a9d9bb4bd54d"
    sha256 cellar: :any,                 big_sur:        "568446ac35a889a5aa2c2352b7319d27274ad3d30c78cccef911c86bbe893d9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b866693bf8cd62d158bc9c27e58b598e2f5859c858a67108707815e665e83cf"
  end

  depends_on "autoconf"  => :build
  depends_on "automake"  => :build
  depends_on "ccache"    => :build
  depends_on "cmake"     => :build
  depends_on "coreutils" => :build
  depends_on "erlang"    => :build
  depends_on "freetds"   => :build
  depends_on "libtool"   => :build
  depends_on "openssl@3"

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
    prefix.install Dir["_build/emqx/rel/emqx/*"]
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
