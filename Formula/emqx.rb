class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https://www.emqx.io/"
  url "https://github.com/emqx/emqx/archive/refs/tags/v5.0.12.tar.gz"
  sha256 "dde5c374f6701e46e26e5835bcc0a74ba312d8a349ad89d2e48498cbaa83ce1b"
  license "Apache-2.0"
  head "https://github.com/emqx/emqx.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "e34729e259a00dda966ae2ea2129321f54e30546a8600f042dbd47476fa54aaa"
    sha256 cellar: :any, arm64_monterey: "60937ff39d0615da13399fbb42db52fe71316a87edb3e0932fd57cd5824f007a"
    sha256 cellar: :any, arm64_big_sur:  "b8500e0ecceac9329196db229f5d066cc3eeadf8ca9786a68108c784d1fb19d9"
    sha256 cellar: :any, ventura:        "0ab8cc929fe9abdeecf27e9fe3a381384275542ee310a8d51e47e0692a507651"
    sha256 cellar: :any, monterey:       "8d46327297a6bdf248281bb162dc292446a7534cc6044e49fde5136719349c19"
    sha256 cellar: :any, big_sur:        "841b46690488901c855cb9dfac22110f8b46ea70e3e66b344d69fc975fa4a939"
    sha256               x86_64_linux:   "7829942a2111840a896090c0c6ba1cba431e85fc6f87726dd54586caadbbd7cc"
  end

  depends_on "autoconf"  => :build
  depends_on "automake"  => :build
  depends_on "cmake"     => :build
  depends_on "coreutils" => :build
  # emqx cannot be built with Erlang/OTP 25 as of v5.0.11,
  # but the support is in the works and is coming soon
  depends_on "erlang@24" => :build
  depends_on "freetds"   => :build
  depends_on "libtool"   => :build
  depends_on "openssl@3"

  uses_from_macos "curl"    => :build
  uses_from_macos "unzip"   => :build
  uses_from_macos "zip"     => :build

  on_linux do
    depends_on "ncurses"
    depends_on "zlib"
  end

  def install
    ENV["PKG_VSN"] = version.to_s
    touch(".prepare")
    system "make", "emqx-rel"
    prefix.install Dir["_build/emqx/rel/emqx/*"]
    rm %W[
      #{bin}/emqx.cmd
      #{bin}/emqx_ctl.cmd
      #{bin}/no_dot_erlang.boot
    ]
  end

  test do
    exec "ln", "-s", testpath, "data"
    exec bin/"emqx", "start"
    system bin/"emqx_ctl", "status"
    system bin/"emqx", "stop"
  end
end
