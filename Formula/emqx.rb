class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https://www.emqx.io/"
  url "https://github.com/emqx/emqx/archive/refs/tags/v5.0.15.tar.gz"
  sha256 "8339b498be51aecfccdf0c423ab336e4272bd7e3abebd9c5bf241226dc656119"
  license "Apache-2.0"
  head "https://github.com/emqx/emqx.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "baededdd38781bf253b44885ce5ecf2faef9cf8763a6fbe1a0e3b0dca092e4a0"
    sha256 cellar: :any, arm64_monterey: "7599d9e411842438601070bf8bcbe76564ad1e0a8f54584cdad4091970bd76cf"
    sha256 cellar: :any, arm64_big_sur:  "71c6dbc62ab62d28ea5f9c1df75564c1a4d4cd1d67b28f6513f2e7b42bda6f57"
    sha256 cellar: :any, ventura:        "ab56a504231d5bafc8204e5a9481e44ffa964e6839ab5e633843aedde26e9495"
    sha256 cellar: :any, monterey:       "36ea307caa022b5329c8775cb2061077713997435d2840a58febf4db2330a915"
    sha256 cellar: :any, big_sur:        "c7450e95fbc7abe43450aff0679657917bb5bc7657fc8d2192eacfefe1d10c45"
    sha256               x86_64_linux:   "96904f77f3b53d2bdd0d8b8d2431f0cc6929061879dcce08b369207af156fcd0"
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
