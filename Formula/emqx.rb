class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https://www.emqx.io/"
  # TODO: Check if we can use unversioned `erlang` at version bump
  url "https://github.com/emqx/emqx/archive/refs/tags/v5.1.4.tar.gz"
  sha256 "e9c5a8f98a3b142211fcc83de6b6c7251677a71d27b207d08ca6cb07c77afc0d"
  license "Apache-2.0"
  head "https://github.com/emqx/emqx.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b5f436cb7ca08d254641faf9d7785757b24daec46fe1c4e834edbe491cde3d38"
    sha256 cellar: :any,                 arm64_monterey: "5dd3a6fb09022bc904627a4aaf04fdd8a1520dffe42bb79775ea23961c440ac2"
    sha256 cellar: :any,                 arm64_big_sur:  "eedcf7821cace8625b532a0ab1fdd1141fffc0ab7299e6df5d6711ef7ac02d2c"
    sha256 cellar: :any,                 ventura:        "c0f706808b0a67f0e8169c82f5aeefc25a86365086fef24ee7e39d5d6bc302c4"
    sha256 cellar: :any,                 monterey:       "d96178a3af7386126be4fd24fdef9446a781502009e4eba4d05b864b16f3a23e"
    sha256 cellar: :any,                 big_sur:        "257ead1ee5f0bcc3d05e9e51f3e08ca506fe789c088638ef8f3cf053258345c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "724850ba28b66b92025824696e53b2c41ae10e5378496a27b3ae15c8954856e1"
  end

  depends_on "autoconf"  => :build
  depends_on "automake"  => :build
  depends_on "ccache"    => :build
  depends_on "cmake"     => :build
  depends_on "coreutils" => :build
  depends_on "erlang@25" => :build
  depends_on "freetds"   => :build
  depends_on "libtool"   => :build
  depends_on "openssl@3"

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
