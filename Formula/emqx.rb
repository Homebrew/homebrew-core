class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https://www.emqx.io/"
  url "https://github.com/emqx/emqx/archive/refs/tags/v5.0.13.tar.gz"
  sha256 "e6645725f77ca75826cbf3249c09e4f569875dac15cfd51cf1260dad173f9de3"
  license "Apache-2.0"
  head "https://github.com/emqx/emqx.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "2ba049891bbe5c750cb7ff453f391d7b63fa603e262b983937ae864a18f26f2f"
    sha256 cellar: :any, arm64_monterey: "1e8cd100d410321e1409c98c9697ce8303cf3d8bfc48f3fbc66e572c17e26109"
    sha256 cellar: :any, arm64_big_sur:  "b9aadbe8e98aa3cb05ccb04fb452738cde49dba34e2204fa681115bdad8664ec"
    sha256 cellar: :any, ventura:        "511f7aebeb02ab09108969746c6c55ed4f1964eea501bcb48a2c363180a08af2"
    sha256 cellar: :any, monterey:       "0758997447bfe912077984f373d09bf2beb085cd2658412e733c0131aba20056"
    sha256 cellar: :any, big_sur:        "8da2df84f5d1137a32d28f1ea0d0022ad83c9bdc41ff11a9cc122f1549df4439"
    sha256               x86_64_linux:   "a9328b1798d0fd0a635dd783992ef372701a1f9e17b9ef24f401ec752d558594"
  end

  depends_on "autoconf"  => :build
  depends_on "automake"  => :build
  depends_on "cmake"     => :build
  depends_on "coreutils" => :build
  depends_on "erlang"    => :build
  depends_on "freetds"   => :build
  depends_on "libtool"   => :build
  depends_on "openssl@1.1"

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
