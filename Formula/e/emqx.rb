class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https://www.emqx.io/"
  url "https://github.com/emqx/emqx/archive/refs/tags/v5.4.0.tar.gz"
  sha256 "4f817fa1e17606262165afe3a806de56b3d2a423deb13c2cc5c8160f7bcc4c75"
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
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "7627aac8bf01843027574b02d6d9d5350cc99a91396be7c29bd3f45fe55d6165"
    sha256 cellar: :any,                 arm64_ventura:  "9bbc9c0cf405ff6c177cf346f5bb93fcb19beccc304112d657c8d5d06c197dcd"
    sha256 cellar: :any,                 arm64_monterey: "a41bfa517fdd5b9a67d0555248ba797454b506865c7fb1bb9725b3deb70e4525"
    sha256 cellar: :any,                 sonoma:         "7b8aab6381acc5f557b08c8da791b57e9b356317cb0582c4f80bc725a34b0daa"
    sha256 cellar: :any,                 ventura:        "298f4b8f2a4e182fc5d7afa6b9ad77f5469d4dcd01eccd2e54ef68c94b742a9f"
    sha256 cellar: :any,                 monterey:       "2027761786553e035fc2481a2b6148cef2179621516e4cc0aaa709e86f687081"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa50983f2e4283e51b7690629a4fa26b87e7676e55a7dd707373c512971534ba"
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
