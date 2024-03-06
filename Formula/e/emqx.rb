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
    sha256 cellar: :any,                 arm64_sonoma:   "a4ea0cfa84d91616fb6a84607ebd6f80cdb9ef092e80b9874dffc6407feaf1d8"
    sha256 cellar: :any,                 arm64_ventura:  "7983e3a11ad7ecf40835dcbc05648bcf61a221cd277b2ec670152bf2fca3911f"
    sha256 cellar: :any,                 arm64_monterey: "5181dc426e4bfa590b84d6a83a1dc7eafe204ce87ea43f4375a89f9e3a97d72c"
    sha256 cellar: :any,                 sonoma:         "8414ad195d547814085458c25917c9e047b7eb244fdcf3e278e4186e6269b1e1"
    sha256 cellar: :any,                 ventura:        "8b3a7e91a7b39e703606eefff6b687b0ee69d9bfaffbb0730b42fc161c347204"
    sha256 cellar: :any,                 monterey:       "6ea6ba4da3162f30c0de6011af9f7b0afb07750d5ae0e7e98677d972cd0ad03d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb31a4e7f86dfca38c7f157f965626374424ad0b8c8e8092069e32c6bf6a90c2"
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
