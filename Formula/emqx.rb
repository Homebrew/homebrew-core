class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https://www.emqx.io/"
  url "https://github.com/emqx/emqx/archive/refs/tags/v5.0.17.tar.gz"
  sha256 "4fadb30b28d2bdad529342cfce55fd00f56d21bcbf929c51479dcbc5648bd1a6"
  license "Apache-2.0"
  head "https://github.com/emqx/emqx.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "cb7bd6a7db03ae4d81587edaf53f4e801554669e7517f2bbdce71a4118d76c9b"
    sha256 cellar: :any, arm64_monterey: "9aa1cfe78346deb6789ef585592c02fe9a7adf34f53fceb94909c4f2874e7471"
    sha256 cellar: :any, arm64_big_sur:  "18564741d01f17319725857832b7cd79f3e47c38d32db5cee29064e24e94b091"
    sha256 cellar: :any, ventura:        "bfa2f8848f57c5d0e4be9d86bc9be05fdb92662837afc5cab12c6e89e16b9761"
    sha256 cellar: :any, monterey:       "b34cc967c29611ab646eea05c9e79f9672dbd3ee9ddd0b6e89d958c5cc886027"
    sha256 cellar: :any, big_sur:        "975b418901135d315f4520bb53d21e041c2cbab8afa835b4ae4993a62e846367"
    sha256               x86_64_linux:   "3b133a5524283dedf86105b96d0f45ac44262526727414984d8aea542cb9320c"
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
