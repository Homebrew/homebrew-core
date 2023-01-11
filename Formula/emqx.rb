class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https://www.emqx.io/"
  url "https://github.com/emqx/emqx/archive/refs/tags/v5.0.14.tar.gz"
  sha256 "6c737e65c9d569c47d47b8de91b93cb11ee4a7ab592e4146c80b6c3c6153887c"
  license "Apache-2.0"
  head "https://github.com/emqx/emqx.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_ventura:  "f4a2a0ebc36c54c1f28430cef90111f2065d6a5a5afb1dba2faa76e19aff75ff"
    sha256 cellar: :any, arm64_monterey: "39bc38439d90c4f8996486f3670ea7fa03c55ba7d9ec77ae8883a0a37db9e016"
    sha256 cellar: :any, arm64_big_sur:  "5f23a80fe9dc573249f05107d126fcea9bb7e5b4967102f7d88a2d2b2423af8f"
    sha256 cellar: :any, ventura:        "3e567fa206d8902b594212a7731681a2563a388342ec0fe39f1ee28c6e2ec530"
    sha256 cellar: :any, monterey:       "c3489f61cfc029cb67bf71d44dc10b6b7b5da8f4bdc60c038f26254a20fc9b9d"
    sha256 cellar: :any, big_sur:        "8ef41cfd62f64c4f002166b2ce1ae56718f0d8cc84a5c342e6a8c52c06b2fec2"
    sha256               x86_64_linux:   "3cb82600e4876682dbdaddc3d5de4a99fdd1aa5087019cbcfed3a1871130e0fa"
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
