class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https://www.emqx.io/"
  url "https://github.com/emqx/emqx/archive/refs/tags/v5.8.8.tar.gz"
  sha256 "5861d8d32c4934175ca3d01c691ea679ac1a7903a1faee72027f6484d3085c89"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "ea4bc45725fd897789f8360bdb243ce2d36936f66326a07d91ad0c3882c9e299"
    sha256 cellar: :any,                 arm64_sequoia: "13dd5052c5746825684505959eb6f411df487913f2adec72720582ff648ddbb5"
    sha256 cellar: :any,                 arm64_sonoma:  "6dd0c8bf218af6232eaf6accbe4485efef61224cbba8b68bdb932e4fa61485cf"
    sha256 cellar: :any,                 sonoma:        "b0753b148145e421a7e9f43db9b07723f7ad5b01592b5d647edc7984b4a25cea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e122333462acf2e5cc639eea4d56afeb80426b619938b941496c7b6e011be16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "130babd6f5e5408a49cccdcfc312106cdca17225031c3978899257c38691408b"
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
  depends_on "openssl@3"

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
