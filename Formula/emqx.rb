class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https://www.emqx.io/"
  url "https://github.com/emqx/emqx/archive/refs/tags/v5.0.26.tar.gz"
  sha256 "50186d65213dd05c1c1e61215e0180fb2b19e2dc656f8ea31b338e947900157f"
  license "Apache-2.0"
  head "https://github.com/emqx/emqx.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ab5ff4145c5f30f5a39ac2fd13eaac929f485cd4b9266c3cec3e0187729ebccc"
    sha256 cellar: :any,                 arm64_monterey: "f9195a7b8da8d363835dd5c74f0ed16ae5e3b9d151e87ad75a778a8bb04dffd0"
    sha256 cellar: :any,                 arm64_big_sur:  "a1b4d0a65f660dd09d2378363c2bdb2ce4ab0af1a691033a398452ca503ec74d"
    sha256 cellar: :any,                 ventura:        "d5c01c46ffd6ebd4d457bbb0730489cf87b8abac28156096d6cd97d230592db8"
    sha256 cellar: :any,                 monterey:       "bb9f75ff12e9858b32576655853003a2b2860f8e40f2c234fe5b727250abedab"
    sha256 cellar: :any,                 big_sur:        "f6ec7b0e41786f10c2b546fe38cc2c300c49e0ff6df1b55e9a32701a202cbff7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11c4b39e0df20d53f04efa77a00749170fe1c3962a85dabab7b6f6e642e36eaf"
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
    prefix.install Dir["_build/emqx/rel/emqx/*"]
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
