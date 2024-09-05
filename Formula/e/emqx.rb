class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https://www.emqx.io/"
  url "https://github.com/emqx/emqx/archive/refs/tags/v5.7.1.tar.gz"
  sha256 "90b1c880d88f47f43dbc6cabf4fbb319ef3f774fc5aa4f2c3405dbd0fa79a02a"
  license "Apache-2.0"
  head "https://github.com/emqx/emqx.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d15cbddc453d1d7b93545977b0db3283acb73f697d461d121185604885d1cc3e"
    sha256 cellar: :any,                 arm64_ventura:  "b6e8f0cc57582c4fd993f394f8bd353daa1a40b769d374c497b84444df3d60d5"
    sha256 cellar: :any,                 arm64_monterey: "c2f64ed96dd0954a52ff0e3e3109b1ddc7c52d97ef383d2282f091c368f9f668"
    sha256 cellar: :any,                 sonoma:         "112150d93a5e3a2a3f2ac95298e1a602fa3e192979b5005fbdf289e0849b19d2"
    sha256 cellar: :any,                 ventura:        "ffaa5bf8f54afe763fb66331fb7cc5e00d842699a3ab9db50ca3f99981478848"
    sha256 cellar: :any,                 monterey:       "8935b538239196965f753eb89e1f8b33dd10c685e1e16264225f490949828b37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e892c081e091c88efcba70caf273f1b66ace28c5289456ba3c5bf2de144ab5f"
  end

  depends_on "autoconf"  => :build
  depends_on "automake"  => :build
  depends_on "ccache"    => :build
  depends_on "cmake"     => :build
  depends_on "coreutils" => :build
  depends_on "erlang@26" => :build
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

  test do
    exec "ln", "-s", testpath, "data"
    exec bin/"emqx", "start"
    system bin/"emqx", "ctl", "status"
    system bin/"emqx", "stop"
  end
end
