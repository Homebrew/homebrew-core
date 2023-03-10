class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https://www.emqx.io/"
  url "https://github.com/emqx/emqx/archive/refs/tags/v5.0.20.tar.gz"
  sha256 "c51dc52d53e812be7d08106dca94236ed58381ff6162f995b029f8d0b01e158a"
  license "Apache-2.0"
  head "https://github.com/emqx/emqx.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a7267ae9704ee6bcaf7ad06a880180dc476e714e9211db3ac5111ee67be067cf"
    sha256 cellar: :any,                 arm64_monterey: "a6cd8281d8f9d8cebcf0ec5846c5ecd3b8f1192c54b5e75d42d26ba885b54f07"
    sha256 cellar: :any,                 arm64_big_sur:  "a8989153785e420a98c6ecd1b9abea2d8279e6a4268e1944ce29eaafa4c01608"
    sha256 cellar: :any,                 ventura:        "b2782b4c50952085d48cc6b8a479ec1381c7123a6123e8316b910e373742afdf"
    sha256 cellar: :any,                 monterey:       "55e4f8460d761a412012b25c0ecdbae3d2623e38f5d8aa72abdf9c7bfaca4b70"
    sha256 cellar: :any,                 big_sur:        "5e9a91a8928803145a8fac49914e5e00e48b01aa90f75d2af21068648d3538e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c92d423226733e27f43b8d281823c5296fb97ff2c80749fa1cb98aa8ddcf5fb7"
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
