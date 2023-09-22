class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https://www.emqx.io/"
  # TODO: Check if we can use unversioned `erlang` at version bump:
  #   https://github.com/emqx/emqx/blob/v#{version}/scripts/ensure-rebar3.sh#L9
  url "https://github.com/emqx/emqx/archive/refs/tags/v5.2.1.tar.gz"
  sha256 "46513ebb562913d3fc945520a4bb77f3ae43578b2931daf44f3df7f909198e18"
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
    sha256 cellar: :any,                 arm64_ventura:  "f74592d13ab2fba6e35a1611e58bc9a4dfd9c04f17b4a338dd55b956964fbf18"
    sha256 cellar: :any,                 arm64_monterey: "fbca9235732050894704099414b0f6fd862a3198944bf78066bec57be8062762"
    sha256 cellar: :any,                 arm64_big_sur:  "dc91eb86ac5b39914ba6ee89e1275dedef5c73e881c1829b7b9e724f9da7c030"
    sha256 cellar: :any,                 ventura:        "7d795bb01581a1ba6a8255be12b550d4794a9833342c795a9189872ab3fda9b9"
    sha256 cellar: :any,                 monterey:       "0c50c48fc8e5ab4d38703739a0406f54803f1f2388dcd5888f96de3895c5ba7f"
    sha256 cellar: :any,                 big_sur:        "b5170279c05269fec6f331389ada0a4a3c2ec325bf8d11d75e26d29fdf995308"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d634479d6b322b88ed4648088482a7435cef6d34161f1209162c4d1a24c5a48c"
  end

  depends_on "autoconf"  => :build
  depends_on "automake"  => :build
  depends_on "ccache"    => :build
  depends_on "cmake"     => :build
  depends_on "coreutils" => :build
  depends_on "erlang@25" => :build
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
