class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https://www.emqx.io/"
  url "https://github.com/emqx/emqx/archive/refs/tags/v5.8.8.tar.gz"
  sha256 "5861d8d32c4934175ca3d01c691ea679ac1a7903a1faee72027f6484d3085c89"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2231cc764c1d69dc8f8b037ae721d9332aba3d74595b602f57e4ffd8de4785d2"
    sha256 cellar: :any,                 arm64_sequoia: "5c6851bb1c28fd010bed1392fa867cd81cf40951d2b52434fb5684d3b5317339"
    sha256 cellar: :any,                 arm64_sonoma:  "3bffe679bd7cfadd14e17903bad317a82ccdff14538909a3495cedd807f92b06"
    sha256 cellar: :any,                 arm64_ventura: "7e51b2ff5ed684be4da3ec5ba4d18eb67e385c39375db088147abcc85215b811"
    sha256 cellar: :any,                 sonoma:        "f2e21ec6a6dbd44b8fd649bde744704016809427fe11a688518448cdb632096e"
    sha256 cellar: :any,                 ventura:       "5a9a1ce9d0b5223f98ada1a7446a11c5c70237e447f40e01b57b270e15383e21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18b5fcdbacd07afb25f4ffbd1f9c777f19ba0f9fcd512ada41ea22e26b5edeb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bd87adc80d3add3e0be9343e3a69ce70cfe53d4c656b5413e2a76af9cbacd5d"
  end

  # https://www.emqx.com/en/news/emqx-adopts-business-source-license
  # https://github.com/emqx/emqx/blob/master/README.md#License
  deprecate! date: "2025-11-30", because: "changed its license to only BUSL in 5.9.0"
  disable! date: "2026-11-30", because: "changed its license to only BUSL in 5.9.0"

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
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

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
  end

  service do
    run [opt_bin/"emqx", "foreground"]
  end

  test do
    ENV["EMQX_LOG_DIR"] = ENV["EMQX_NODE__DATA_DIR"] = testpath
    assert_match "started successfully!", shell_output("#{bin}/emqx start")
    assert_match "is started", shell_output("#{bin}/emqx ctl status")
  ensure
    system bin/"emqx", "stop"
  end
end
