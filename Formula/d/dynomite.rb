class Dynomite < Formula
  desc "Generic dynamo implementation for different k-v storage engines"
  homepage "https://github.com/Netflix/dynomite"
  url "https://github.com/Netflix/dynomite/archive/refs/tags/v0.6.22.tar.gz"
  sha256 "9c3c60d95b39939f3ce596776febe8aa00ae8614ba85aa767e74d41e302e704a"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256                               arm64_tahoe:    "ec342954369e6726e60c027f71e8e1fb3e6fcc8fba63255ba73149a02fa50043"
    sha256                               arm64_sequoia:  "e1eb2ecffe6ef0e08d0cc80b5f5ca44a337e2c4d79dde61be3ad2002d2e31fd3"
    sha256                               arm64_sonoma:   "1c273876dda80923311eed315f5c69de5e692fe4a666e7e937954895dd9f57c0"
    sha256 cellar: :any,                 arm64_ventura:  "757afdc3438ad136afef540fee6a07e42a51b3c1bbde3a25fb13bd19e5807d33"
    sha256 cellar: :any,                 arm64_monterey: "682e0e5ec05ccfdd2fe8142083153dc6a0c14d3b1d7cc8c0dc1cd425aded9e41"
    sha256 cellar: :any,                 arm64_big_sur:  "edd9fad6b17b83dbf2d2699c3873463ea169a996fed83e861652bb5f92de4d7a"
    sha256                               sonoma:         "1f189756392ee5476ffd10499b054c0d21a71b5addd75632cd84a37a3a4f25ce"
    sha256 cellar: :any,                 ventura:        "98d4209a06b832e81859388bd4da429cdbd87f9103d31656b2d094375221e1fa"
    sha256 cellar: :any,                 monterey:       "5679f89f06a1f5ac53e3c4d2481f35e944238be44579423aab64077e5033c637"
    sha256 cellar: :any,                 big_sur:        "8a79d6ed731e5a44a26b5691723edc02ca0ed66e4c54fa08bdc183082dd8531b"
    sha256 cellar: :any,                 catalina:       "879a8a2ca6905ca4cd0cf3cc7e6020415b54b12f3a90f51e52a289c1818da46a"
    sha256                               arm64_linux:    "2839e6134a007f1e5471394362bef65e4083c1a17c98ec6fe51caac34e349b81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9251d7d3c85de18d648cee8fec1d415a634a820efe26559702a61b01f47c0e52"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@3"

  # Apply fix for -fno-common from gcc-10 branch
  # Ref: https://github.com/Netflix/dynomite/issues/802
  patch do
    on_linux do
      url "https://github.com/dmolik/dynomite/commit/303d4ecae95aee9540c48ceac9e7c0f2137a4b52.patch?full_index=1"
      sha256 "a195c75e49958b4ffcef7d84a5b01e48ce7b37936c900e466c1cd2d96b52ac37"
    end
  end

  def install
    # Work around build failure on recent Clang
    # Issue ref: https://github.com/Netflix/dynomite/issues/818
    if DevelopmentTools.clang_build_version >= 1500
      ENV.append_to_cflags "-Wno-implicit-function-declaration -Wno-int-conversion"
    end

    args = ["--disable-silent-rules", "--sysconfdir=#{pkgetc}"]
    # Help old config script for bundled libyaml identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
    pkgetc.install Dir["conf/*"]
  end

  test do
    stats_port = free_port

    cp etc/"dynomite/redis_single.yml", testpath
    inreplace "redis_single.yml" do |s|
      s.gsub! ":8102", ":#{free_port}"
      s.gsub! ":8101", ":#{free_port}"
      s.gsub! ":22122", ":#{free_port}"
      s.gsub! ":22222", ":#{stats_port}"
    end

    fork { exec sbin/"dynomite", "-c", "redis_single.yml" }
    sleep 5
    assert_match "OK", shell_output("curl -s 127.0.0.1:#{stats_port}")
  end
end
