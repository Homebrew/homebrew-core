class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https://www.emqx.io/"
  url "https://github.com/emqx/emqx/archive/refs/tags/v5.0.13.tar.gz"
  sha256 "e6645725f77ca75826cbf3249c09e4f569875dac15cfd51cf1260dad173f9de3"
  license "Apache-2.0"
  head "https://github.com/emqx/emqx.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "13802e1e73c46b59a9643db5136b0ca7f52e285db0b878d2a86a3891ab384df9"
    sha256 cellar: :any, arm64_monterey: "5d390390916f62a5eedca9a7ed23af0c75bf11ac5cbe1c77729c0d0d7cc0585b"
    sha256 cellar: :any, arm64_big_sur:  "6f37c66ea50078b9e750ae2a82332a09f460e5969d2b6dc2209133d3753e5657"
    sha256 cellar: :any, ventura:        "ad40d3dd85455c92aa5f698d08c07135036ce6c15c7339e3e5d6cfdae3250ae1"
    sha256 cellar: :any, monterey:       "f9d267822fed84a13d218c2d41f322510d5a8ededd62cf56ce204a42255e7195"
    sha256 cellar: :any, big_sur:        "a2eb5e0753e3f27e36a2975b3fc489299c235cc3d91fd0f4ded16296969e85c3"
    sha256               x86_64_linux:   "2f1ccf11a2b8bdd84f172712451b80cfbd56c0d6a1abf9fdc6abb7dca9a60d18"
  end

  depends_on "autoconf"  => :build
  depends_on "automake"  => :build
  depends_on "ccache"    => :build
  depends_on "cmake"     => :build
  depends_on "coreutils" => :build
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
