class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https://www.emqx.io/"
  url "https://github.com/emqx/emqx/archive/refs/tags/v5.7.0.tar.gz"
  sha256 "e6295b342191e53a4ce91dbaea018858a1aae3ee25a33ccc69af4c0eb425d25b"
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
    sha256 cellar: :any,                 arm64_sonoma:   "2fcd1acb2ecf6ea2018086bf123d865a4432f0bc58cbe6fc195cf084b72d117d"
    sha256 cellar: :any,                 arm64_ventura:  "436d596e9f1d4acbc8824845708fcc00c959a5ffdfde6cf5c3925d3be11447b6"
    sha256 cellar: :any,                 arm64_monterey: "202252b093cd0204f0d670da6765ed704528927da12b1f93b5e5cca67732212a"
    sha256 cellar: :any,                 sonoma:         "29fb18dd1ee371285a5d495fbb420ec118454846dbdc61fdd8f8dbfbcf6945eb"
    sha256 cellar: :any,                 ventura:        "0037843d6e5c8fd9437054ec7c8b5ea87730061e6eefef86569dd317ff469c24"
    sha256 cellar: :any,                 monterey:       "1cd02e52282691ff3d87dad0d5eec5b26ad9316b4ae3ab470f7356e595921ce3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06d404310688a82a52d0d8d92706cf914a0f99e7f9ab3516e10772d3956e37e0"
  end

  depends_on "autoconf"  => :build
  depends_on "automake"  => :build
  depends_on "ccache"    => :build
  depends_on "cmake"     => :build
  depends_on "coreutils" => :build
  depends_on "erlang" => :build
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
