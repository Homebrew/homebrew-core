class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https://www.emqx.io/"
  url "https://github.com/emqx/emqx/archive/refs/tags/v5.5.1.tar.gz"
  sha256 "db907d7a42c76c8954bd56de02c168acf35d160873b48b960dbd10b1c8e0026c"
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
    sha256 cellar: :any,                 arm64_sonoma:   "1f6e18141a5c2347532fe3ecfeae628bc5945a93747e86cd4667422b3687a0a9"
    sha256 cellar: :any,                 arm64_ventura:  "d0a2dfa991bafd1ac5e8474b600f575af9d03327cd4122078ecf08ebd80aaa33"
    sha256 cellar: :any,                 arm64_monterey: "713b5d5cb70f7bab23d2c41b9275d7b7ed61cbb024d3803dbe08e7d77e7ab0b7"
    sha256 cellar: :any,                 sonoma:         "0b33135c9a244b8379fafd828fda70a555179c2cd83440579d4e72535e304ab8"
    sha256 cellar: :any,                 ventura:        "1727224774e1b8a3bbd07e6fbd2d422b65bd87feb3f965fa143627b735218720"
    sha256 cellar: :any,                 monterey:       "833ea8db48a38707a7308fa0036b45baae15dd36ff42bfb5f3fe7244cf81da14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "864360c8b6e19afeb952e7a4590ada9a7392f45a953001abda9e639580521ef3"
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
