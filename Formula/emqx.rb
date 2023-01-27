class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https://www.emqx.io/"
  url "https://github.com/emqx/emqx/archive/refs/tags/v5.0.15.tar.gz"
  sha256 "8339b498be51aecfccdf0c423ab336e4272bd7e3abebd9c5bf241226dc656119"
  license "Apache-2.0"
  head "https://github.com/emqx/emqx.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "d0ea0e3391ad365ee42fa6795c0b5a585563ca246d1381f85fab0ef4219f2870"
    sha256 cellar: :any, arm64_monterey: "9b85755549dcb89bdc2f1af808ef195d0ffa4bb8869d8e62d7d2dd5737aff406"
    sha256 cellar: :any, arm64_big_sur:  "9f27ad81d2e13251cd2e193f072d99d66a8135a081d7d5fb3a5275e5e0c90f29"
    sha256 cellar: :any, ventura:        "39d69f50d970186afcd6dcb6668b818f3c9c8266517b4c2468b11cc841e570d8"
    sha256 cellar: :any, monterey:       "608c4e991d863b13e44d86d1b01145b825d5854e070cf59878e92adb84cf76bd"
    sha256 cellar: :any, big_sur:        "02d2b2d527c1c5b147f2b446eb30d7b14237e248d323292ae1d6d17f38874498"
    sha256               x86_64_linux:   "4cafb24c183f515a3cca26c686959b2b77df45c8086fcdcbaf46e967a3124deb"
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
