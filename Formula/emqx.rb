class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https://www.emqx.io/"
  url "https://github.com/emqx/emqx/archive/refs/tags/v5.0.26.tar.gz"
  sha256 "73af5be5bf0415514b7c36cb08ea3e6fc65339b43b4a5d69aec053d001355f54"
  license "Apache-2.0"
  head "https://github.com/emqx/emqx.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "93ef3cd9afd2c92bd2bb0b6fcc16017b6a85c63068459c00975a518419742993"
    sha256 cellar: :any,                 arm64_monterey: "c5b0e2a82e6c32121374dc8df88bd4ee11c7c448f560e9db8a37578dd4128fdc"
    sha256 cellar: :any,                 arm64_big_sur:  "e43af0822e0a364dd01996600e3369ba3a65a79521bc2fdd492b759bbe7c93d7"
    sha256 cellar: :any,                 ventura:        "0473fcc64da43475aede6edbf98ae9bfc3192e95a265377d35ae7e106ad30cee"
    sha256 cellar: :any,                 monterey:       "e33b92cc92d87a072cc589d8c1a50fb86c9691f6a21344a7d4d2b5e2d2499406"
    sha256 cellar: :any,                 big_sur:        "94c19edd4537971f9f26dc2777b39bcdd3bd54183e1cdeb85cec2464b16b4efb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b581cc034e6b871bf21dca1fa495b1f46ac87eded7f4dc2a34190e3c10b888b"
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
