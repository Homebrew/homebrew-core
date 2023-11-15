class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https://www.emqx.io/"
  # TODO: Check if we can use unversioned `erlang` at version bump:
  #   https://github.com/emqx/emqx/blob/v#{version}/scripts/ensure-rebar3.sh#L9
  url "https://github.com/emqx/emqx/archive/refs/tags/v5.3.1.tar.gz"
  sha256 "11c3fead5af8359da7c55b74a0b4e9fb6a980f9e7b0752684867e65eda897fe9"
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
    sha256 cellar: :any,                 arm64_sonoma:   "ca4c303352f820c8d0167902e99f2c77a94f25624df35546c3d0354e0771f0ea"
    sha256 cellar: :any,                 arm64_ventura:  "e7e554eb0d3eb6a0b252a2ba87cff7ff262b431eb9842a909fe5278927be8d11"
    sha256 cellar: :any,                 arm64_monterey: "5cfdc23d3e14fa9e6637c1bfe4fece6e3942f0382ca8e2da34f749967837c5db"
    sha256 cellar: :any,                 sonoma:         "0629ffef4adfbb671018e0e24e14d7784f310aba37d9275c14e0a2b77eab7173"
    sha256 cellar: :any,                 ventura:        "cd91b2b24e31ee9b1b8d8de732b4be183998a29f654e5bee8c1d4731604758d9"
    sha256 cellar: :any,                 monterey:       "09930459b416581d7609e45bff2472f4d2faa173a64de1b9a652252cb1d25417"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "adb64dafa5afab5325ef563ded57640de9160d561e4d1356c6b73510b2e80b0f"
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
