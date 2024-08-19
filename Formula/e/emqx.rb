class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https://www.emqx.io/"
  url "https://github.com/emqx/emqx/archive/refs/tags/v5.7.2.tar.gz"
  sha256 "4866630a83bb4d5415f9aa7629b79a1868ad4bcf16948f60d08af1c369250ed7"
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
    sha256 cellar: :any,                 arm64_sonoma:   "b53ae3b7ba69e112fedcfac7573e02b5ca706461459ab7f1c4abdf6155da74ce"
    sha256 cellar: :any,                 arm64_ventura:  "0fb56773097600cb77e710d5eec74dc55cc2fc9067f22112a176df1f7fdaeb8c"
    sha256 cellar: :any,                 arm64_monterey: "7eb041e7302f18ee6c19f37fa44f8c5d7eeb73414ba602e08a11d2a27e650cb2"
    sha256 cellar: :any,                 sonoma:         "12761e56cc5f388c9b88bfad46a6b80cd56ffb613b6c86a26d9768375560f2e3"
    sha256 cellar: :any,                 ventura:        "6cfb05c4c71a90b2cf87475d8234e2f25cb8370c46a71241a8464bda4dae3cf7"
    sha256 cellar: :any,                 monterey:       "24d5ff27a5a6deb9fdd9c66e8fc0b421380b15a2bbde3b5d7b17826c91643125"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3227bdc15077985fa22aab745365a0a3b395946ec69c4bf15cfc634004e3623"
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
