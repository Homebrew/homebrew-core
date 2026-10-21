class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https://www.emqx.io/"
  url "https://github.com/emqx/emqx/archive/refs/tags/v5.8.8.tar.gz"
  sha256 "5861d8d32c4934175ca3d01c691ea679ac1a7903a1faee72027f6484d3085c89"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3aee423290d705a6278a2a408b967c30bb06f462a8fc4c5ff477d2282fa01b43"
    sha256 cellar: :any, arm64_tahoe:       "079191e3f9d1772bfef9e622545ae4efb7774e28c839708a26550df9e273a5e9"
    sha256 cellar: :any, arm64_sequoia:     "a326711e60e87d6b5d1d286ec79715715e6cd3cc6c9fc88df4544c944985b0a2"
    sha256 cellar: :any, arm64_linux:       "b755ea36997f557d4de910e38ce72dd541d1ba40ed3c50ebfeccf78f24dcc9db"
    sha256 cellar: :any, x86_64_linux:      "d94cbee08764f04e6a9f34bbb0b40f3a591332dc231b1a16b6f389559b254bd8"
  end

  # https://www.emqx.com/en/news/emqx-adopts-business-source-license
  # https://github.com/emqx/emqx/blob/master/README.md#License
  deprecate! date: "2025-11-30", because: "changed its license to only BUSL in 5.9.0"
  disable! date: "2026-11-30", because: "changed its license to only BUSL in 5.9.0"

  depends_on "autoconf"  => :build
  depends_on "automake"  => :build
  depends_on "cmake"     => :build
  depends_on "coreutils" => :build
  depends_on "erlang@26" => :build
  depends_on "freetds"   => :build
  depends_on "libtool"   => :build
  depends_on "openssl@4"

  uses_from_macos "curl"       => :build
  uses_from_macos "unzip"      => :build
  uses_from_macos "zip"        => :build
  uses_from_macos "cyrus-sasl"
  uses_from_macos "krb5"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "cassandra", because: "both install `nodetool` binaries"

  def install
    # Workaround for cmake version 4
    ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"

    ENV["PKG_VSN"] = version.to_s
    ENV["BUILD_WITHOUT_QUIC"] = "1"

    # Workaround to avoid C23
    ENV["ac_cv_prog_cc_c23"] = "no"

    touch(".prepare")
    system "make", "emqx-rel"

    prefix.install Dir["_build/emqx/rel/emqx/*"]
    %w[emqx.cmd emqx_ctl.cmd no_dot_erlang.boot].each do |f|
      rm bin/f
    end
    chmod "+x", prefix/"releases/#{version}/no_dot_erlang.boot"
    bin.install_symlink prefix/"releases/#{version}/no_dot_erlang.boot"
  end

  service do
    run [opt_bin/"emqx", "foreground"]
  end

  test do
    ENV["EMQX_LOG_DIR"] = ENV["EMQX_NODE__DATA_DIR"] = testpath
    assert_match "started successfully!", shell_output("#{bin}/emqx start")
    assert_match "is started", shell_output("#{bin}/emqx ctl status")
  ensure
    system bin/"emqx", "stop"
  end
end
