class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https://www.emqx.io/"
  url "https://github.com/emqx/emqx/archive/refs/tags/v5.0.23.tar.gz"
  sha256 "4fdd6ca89640eb55217c9b1f576c7b6b59eb69412def8c9a8ac60d84b667e9fc"
  license "Apache-2.0"
  head "https://github.com/emqx/emqx.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "00de03b25e6b2f2ca319742aed5b3bfe9a31015c419ef9e1b19d72c90eb777e0"
    sha256 cellar: :any,                 arm64_monterey: "9eaffc6114106f6f289c55276e56e21919dfb13e9fbd5e123fdf085c4376f068"
    sha256 cellar: :any,                 arm64_big_sur:  "88a089a70b985060902a57d7f30c39da41c6a6a0ae026bdfdc0a0f1cb8bf6162"
    sha256 cellar: :any,                 ventura:        "03c3b49c93680f3a5b2c4b83896a85ff3afc011fd4fee2fdf426193653d25540"
    sha256 cellar: :any,                 monterey:       "6414a12418592eb9438f1537bac197e7f3bcfdb27837391542ace30d51467eb4"
    sha256 cellar: :any,                 big_sur:        "bf081f29df239308292c32b2abb3835cdee5c1758af6f8097e93161ac6f3c92b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00b39fc29cbf63c30ed94538a6c1104acc415f160173b5245fcabe93c19f70a0"
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
