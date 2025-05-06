class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https://www.emqx.io/"
  url "https://github.com/emqx/emqx/archive/refs/tags/v5.8.6.tar.gz"
  sha256 "7652c6365cac87143ef8fc99bd4d3ece932dfde15c19d315b7a37bd1026cd98f"
  license "Apache-2.0"
  head "https://github.com/emqx/emqx.git", branch: "master"

  # Exclude beta and release canditate tags (`-rc` and `-beta` suffixes)
  # and enterprise versions with BUSL license (their tag starts with `e`)
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "635f75a36b9a684d3d12e3140fe227b626f97cbc7aedbd1d3d4187f19125202c"
    sha256 cellar: :any,                 arm64_sonoma:  "14b3027a6c06f5cc1aa958f6e62bad88a5ba843795d588ebd2a23cb216703384"
    sha256 cellar: :any,                 arm64_ventura: "58475350df25bc890b392fbf7b4f1996e37577b795ec7a5d1989928d546719d9"
    sha256 cellar: :any,                 sonoma:        "d2d97364d818a40e08f0a047c470b682647bb0859d9ddf4d0bdd1220a46ddf9f"
    sha256 cellar: :any,                 ventura:       "d95d5ea7d09407b8e129f609adb486d8cff5f3cd14f9ac2a8aa36ec6783f43ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d138f648c78ee92a50839a66f94c447fcb16e877d4240476dae5b2eb191fa5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebe73f248da88a0c7be48c539cd4d56a28688ec75ecbc4e0c53bf202fa2cab90"
  end

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

  on_linux do
    depends_on "ncurses"
    depends_on "zlib"
  end

  conflicts_with "cassandra", because: "both install `nodetool` binaries"

  def install
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
    return unless OS.mac?

    # ensure load path for libcrypto is correct
    crypto_vsn = Utils.safe_popen_read("erl", "-noshell", "-eval",
                                       'io:format("~s", [crypto:version()]), halt().').strip
    libcrypto = Formula["openssl@3"].opt_lib/shared_library("libcrypto", "3")
    %w[crypto.so otp_test_engine.so].each do |f|
      dynlib = lib/"crypto-#{crypto_vsn}/priv/lib"/f
      old_libcrypto = dynlib.dynamically_linked_libraries(resolve_variable_references: false)
                            .find { |d| d.end_with?(libcrypto.basename) }
      next if old_libcrypto.nil?

      dynlib.ensure_writable do
        dynlib.change_install_name(old_libcrypto, libcrypto.to_s)
        MachO.codesign!(dynlib) if Hardware::CPU.arm?
      end
    end
  end

  service do
    run [opt_bin/"emqx", "foreground"]
  end

  test do
    exec "ln", "-s", testpath, "data"
    exec bin/"emqx", "start"
    system bin/"emqx", "ctl", "status"
    system bin/"emqx", "stop"
  end
end
