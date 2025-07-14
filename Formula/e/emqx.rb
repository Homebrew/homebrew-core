class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https://www.emqx.io/"
  url "https://github.com/emqx/emqx/archive/refs/tags/v5.8.7.tar.gz"
  sha256 "3536b48d5ec1b69e498c1abd48cf074bfc403f7fca8c616477851cdcbc1c63b8"
  license "Apache-2.0"
  head "https://github.com/emqx/emqx.git", branch: "master"

  # Exclude beta and release canditate tags (`-rc` and `-beta` suffixes)
  # and enterprise versions with BUSL license (their tag starts with `e`)
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6f6973c4b8c090856066a3aa8dfdffd5c2eb336a10a0febb9e30d6ba62c95d67"
    sha256 cellar: :any,                 arm64_sonoma:  "67db4e2cd4aed71409f3a1e41db676181744f1d44fc677d00803baa7e21ad5f8"
    sha256 cellar: :any,                 arm64_ventura: "83afced79ba880bf1304e594dce2f860d1c6fd3cd50792f906354629abfb3c5b"
    sha256 cellar: :any,                 sonoma:        "18238971951417123f928edd4e7eadb3881f58e0ede50d68e0acc2c160b878b5"
    sha256 cellar: :any,                 ventura:       "1b32912908f26dbfd60a84a30996efc6af3e4e89a0ed2c45d00cdebf6e89d63b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edfd7daed5e1f9c2b62290008386546a9038df7617df224465607f5c20f756fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee33d491701b8fe2632dda69836f5dba501f51ef52d5df6d1f93b8366787afc4"
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
