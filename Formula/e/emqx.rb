class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https://www.emqx.io/"
  # TODO: Check if we can use unversioned `erlang` at version bump:
  #   https://github.com/emqx/emqx/blob/v#{version}/scripts/ensure-rebar3.sh#L9
  url "https://github.com/emqx/emqx/archive/refs/tags/v5.1.6.tar.gz"
  sha256 "ae3d9a0dfbc91de9c54d447ab32310230f33837c933b4ab0405775c944ce5bef"
  license "Apache-2.0"
  head "https://github.com/emqx/emqx.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "792df9f7e11ae9cb767b94b61707e31bd6e3926712153177696644823b402078"
    sha256 cellar: :any,                 arm64_monterey: "2f123fa9f940697a52d49f3ba9786dcddb75ee169f949210d22627371650426b"
    sha256 cellar: :any,                 arm64_big_sur:  "9523de0783bd80b7635d3d205aab1981b9dff4fce3e85b17d705e2a4617d00b9"
    sha256 cellar: :any,                 ventura:        "6f5e1b70f5c6b700bdf9e3288a5675c4587726983f3b630ab8a7519ae0f7f8fe"
    sha256 cellar: :any,                 monterey:       "d124ce387a3c2515d5bb269ee88e6ce7a42b5ab100a770ec970f5f2341dbec05"
    sha256 cellar: :any,                 big_sur:        "6fdfa5973703087ded9c1cbf7c47bdd83bd6e186bd0a9d0e6729d908df73587a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1049dcc17e2b1810493bda435beff593379eeb6d36c2e6221d13491f5d4bb86f"
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
