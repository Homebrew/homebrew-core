class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https://www.emqx.io/"
  url "https://github.com/emqx/emqx/archive/refs/tags/v5.6.1.tar.gz"
  sha256 "1896399da468b20c0637875ebfe28a9519e1c2bf85a1fdd33c90e726f72287b0"
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
    sha256 cellar: :any,                 arm64_sonoma:   "3553ebd4aa99f89bf2107484738d955a8eb1df1ed91370420e193e020d3249e9"
    sha256 cellar: :any,                 arm64_ventura:  "190d27b0eadc9bc94b7e6a982cccd3fa93b3b5ab8fbcf1791631bd42ca1dc520"
    sha256 cellar: :any,                 arm64_monterey: "868c5accf082bb53564f6b091b8f7289b87b5733b26179ecedac322290d2b076"
    sha256 cellar: :any,                 sonoma:         "f83c5764e3fff3c520f81831a5d40ecfdf33428366c1fa6ec00794baf11d8405"
    sha256 cellar: :any,                 ventura:        "ff6b462aabd8f76e54d616f6e39dbddab44bd3400dbb65bb25f657e358ca01c1"
    sha256 cellar: :any,                 monterey:       "97617d73f980fcabd11ec00b5d2470b1caf52bc337cbd3f9a2fb8ed708d4a27e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a7036b24986e97851d65c49b9b7b10874e99bcc2ac5c02e554e5450db49baa4"
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
