class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https://www.emqx.io/"
  url "https://github.com/emqx/emqx/archive/refs/tags/v5.0.22.tar.gz"
  sha256 "eea10576ddbc121228dfa6ffaf5818ad3ad619831dc68f2fe47eff5970f3e967"
  license "Apache-2.0"
  head "https://github.com/emqx/emqx.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8fec039ff97a451ae939dc66cdfc9cd765663997b1c46b8b30b1b0bfa81e41c0"
    sha256 cellar: :any,                 arm64_monterey: "f5970b52211e84d12a46ae82a731c8bda8456e79bb688a68819354c64513cd69"
    sha256 cellar: :any,                 arm64_big_sur:  "e08e0d959ddb785feea3f5e487111f1ce6d49e5e5630da7aa8d9d22a49270435"
    sha256 cellar: :any,                 ventura:        "1366853a8136591e2f9c9b53ced0a6f6b5a5ec6a19523051c753ca429ce967fb"
    sha256 cellar: :any,                 monterey:       "23497c648161f93de92bb61cd2a7343d913d42b4d25e090b7893d74a2f6684b7"
    sha256 cellar: :any,                 big_sur:        "65d0eb5d51dc5c264d6fe03940dfbc9ea2303a27f2a653ad89e452f8c3592d61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7efa340cccd1071431f43ed13ed8d76ba4728383e013ce5c91a97ae178c69805"
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
