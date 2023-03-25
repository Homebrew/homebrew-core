class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https://www.emqx.io/"
  url "https://github.com/emqx/emqx/archive/refs/tags/v5.0.21.tar.gz"
  sha256 "1167eccc4bf04d7c6e124d03218e3d6dc7fcea255b530dd4bbe4fcc27b35b142"
  license "Apache-2.0"
  head "https://github.com/emqx/emqx.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8e00ea523cea4358eb95b6b59b50f007c505cdff208c90d5b1e24790139d07a6"
    sha256 cellar: :any,                 arm64_monterey: "a6645430ccff7142edb251ec1475abfd825ea0a70a9619ae6c60b60c9c83c02a"
    sha256 cellar: :any,                 arm64_big_sur:  "91dd349cc9e37e7848fc151c9abe2a15707cb9652185a096439a20661039348a"
    sha256 cellar: :any,                 ventura:        "e9daab8c0ed995f404d6e9b5dec54630510c0c90903c3be7f36a3899319fb670"
    sha256 cellar: :any,                 monterey:       "047e09bd19d36c0e30c089a6e4f29eda06893c2b835f859c793c4a57180160da"
    sha256 cellar: :any,                 big_sur:        "e0dfd8e2b04859abecd813ad99f5bb6e14e341079d1430dfc1b69c793ac8bddb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7aef2f35b39222c694698569fced5402ea5c5bc1201cc7f5e27da244b4dc9978"
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
