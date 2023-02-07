class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https://www.emqx.io/"
  url "https://github.com/emqx/emqx/archive/refs/tags/v5.0.16.tar.gz"
  sha256 "6c337fc1d03edd8988a949ccd785b924a1676013d7e2146fc3eea4860ca2522c"
  license "Apache-2.0"
  head "https://github.com/emqx/emqx.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_ventura:  "0beef3c9b067cd7d1e85a70acffbeaf1b2d835d8af03fb450d9aca066721c000"
    sha256 cellar: :any, arm64_monterey: "b283d3e14fcb1643ff97f1cb6581dc5584c86bf79746b8f2bc1b90d49c6d2c3c"
    sha256 cellar: :any, arm64_big_sur:  "71b2ea50a469e427ce76dc7f83ca940e7527060fa6d9dc00bd77cb78b7abe0aa"
    sha256 cellar: :any, ventura:        "7e0aef259ab4274b28b958bd76934d3d011d83785d9543661650279933e58bf1"
    sha256 cellar: :any, monterey:       "b3eee5b5bb6d9ebbc4a4108df5d2ad28430b932d282119264fc1ed2af4576e41"
    sha256 cellar: :any, big_sur:        "fce7177736a3e1285611fc8873cc60e36b5645ecb731e24fc0b40044b26bbdf7"
    sha256               x86_64_linux:   "9423ebbb1fd5d800459a9f667f209d2e177310c383be3857eb54f865d4a78eef"
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
