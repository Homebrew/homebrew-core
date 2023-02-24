class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https://www.emqx.io/"
  url "https://github.com/emqx/emqx/archive/refs/tags/v5.0.18.tar.gz"
  sha256 "86fd7cad7d62630eb7ae6eb8ecb6a92d298695fe72bc8a2c15630629712bf4fb"
  license "Apache-2.0"
  head "https://github.com/emqx/emqx.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "e0bdaebbf52cfe482dc052560c40b9885b48cc82cf1692a7a09a2ce507515820"
    sha256 cellar: :any, arm64_monterey: "41198334dcb55b82e9517e6ae1481171042e4cf1b676051509e6e5a8d81ec796"
    sha256 cellar: :any, arm64_big_sur:  "f3b8d0b56cbe2090db51f6e1cdaa1165796252fbab73a7c0ba7539d722e1089c"
    sha256 cellar: :any, ventura:        "db7d6080d74aa415b63c707d75bd624a8b046a835e3189d8336ba0d6e9b9a042"
    sha256 cellar: :any, monterey:       "113a9d20183fe3b918861923a0893201ed25084032744166fc07d9b1df180aa0"
    sha256 cellar: :any, big_sur:        "56a6664c0ebafda67df336cc3886db73f2d1d2b211d95cdecbed790d9cbab7fa"
    sha256               x86_64_linux:   "5d0a03a8ddede04390b2a1c5036a46028fad8aee5470ade02fdc97d01b9255dd"
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
