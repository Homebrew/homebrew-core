class Emqx < Formula
  desc "MQTT broker for IoT"
  homepage "https://www.emqx.io/"
  url "https://github.com/emqx/emqx/archive/refs/tags/v5.8.0.tar.gz"
  sha256 "dcacbe46468d16bcf8eb9cf8fb4d3326543fd5f23dc9dd00c846430423b011a4"
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
    sha256 cellar: :any,                 arm64_sequoia: "1e4fcff2f14987bbe1ec516ed98c9ab0e6bb4a188d7081c425debe531c5247ef"
    sha256 cellar: :any,                 arm64_sonoma:  "3af40e155dc7e6d98eda55705f1cb42def2802621812cd80bae0ddb74d5ead3d"
    sha256 cellar: :any,                 arm64_ventura: "30f68f9e3363818929b2f030a589571667dc2a9b28262b187386f1f825d79f69"
    sha256 cellar: :any,                 sonoma:        "e69a0ae0b2855a2b6d2c61469ff001c802f914b6ab2aa03ebafa651265f690db"
    sha256 cellar: :any,                 ventura:       "5d4a5fa634f02d505101e5d0a75109248779830426e5d085732d6049b87fbca9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa80edc808b520c4572cf13cc4969008730d8ff028440f325bc75b152ac93c9a"
  end

  depends_on "autoconf"  => :build
  depends_on "automake"  => :build
  depends_on "ccache"    => :build
  depends_on "cmake"     => :build
  depends_on "coreutils" => :build
  depends_on "erlang@26" => :build
  depends_on "freetds"   => :build
  depends_on "libtool"   => :build
  depends_on "openssl@3"

  uses_from_macos "curl"       => :build
  uses_from_macos "cyrus-sasl" => :build
  uses_from_macos "krb5"       => :build
  uses_from_macos "unzip"      => :build
  uses_from_macos "zip"        => :build

  on_linux do
    depends_on "ncurses"
    depends_on "zlib"
  end

  conflicts_with "cassandra", because: "both install `nodetool` binaries"

  patch :DATA

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

__END__
diff --git a/apps/emqx_auth_kerberos/rebar.config b/apps/emqx_auth_kerberos/rebar.config
index 8649b8d0..738f68f8 100644
--- a/apps/emqx_auth_kerberos/rebar.config
+++ b/apps/emqx_auth_kerberos/rebar.config
@@ -3,5 +3,5 @@
 {deps, [
     {emqx, {path, "../emqx"}},
     {emqx_utils, {path, "../emqx_utils"}},
-    {sasl_auth, "2.3.0"}
+    {sasl_auth, "2.3.2"}
 ]}.
diff --git a/apps/emqx_bridge_kafka/rebar.config b/apps/emqx_bridge_kafka/rebar.config
index fd905658..99d576f8 100644
--- a/apps/emqx_bridge_kafka/rebar.config
+++ b/apps/emqx_bridge_kafka/rebar.config
@@ -10,7 +10,7 @@
     {emqx_connector, {path, "../../apps/emqx_connector"}},
     {emqx_resource, {path, "../../apps/emqx_resource"}},
     {emqx_bridge, {path, "../../apps/emqx_bridge"}},
-    {sasl_auth, "2.3.0"}
+    {sasl_auth, "2.3.2"}
 ]}.
 
 {shell, [
diff --git a/mix.exs b/mix.exs
index b9031a70..7c977ab1 100644
--- a/mix.exs
+++ b/mix.exs
@@ -215,7 +215,7 @@ defmodule EMQXUmbrella.MixProject do
 
   # in conflict by emqx_connector and system_monitor
   def common_dep(:epgsql), do: {:epgsql, github: "emqx/epgsql", tag: "4.7.1.2", override: true}
-  def common_dep(:sasl_auth), do: {:sasl_auth, "2.3.0", override: true}
+  def common_dep(:sasl_auth), do: {:sasl_auth, "2.3.2", override: true}
   def common_dep(:gen_rpc), do: {:gen_rpc, github: "emqx/gen_rpc", tag: "3.4.0", override: true}
 
   def common_dep(:system_monitor),
diff --git a/rebar.config b/rebar.config
index 551ec665..ccf2d239 100644
--- a/rebar.config
+++ b/rebar.config
@@ -100,7 +100,7 @@
     {snabbkaffe, {git, "https://github.com/kafka4beam/snabbkaffe.git", {tag, "1.0.10"}}},
     {hocon, {git, "https://github.com/emqx/hocon.git", {tag, "0.43.3"}}},
     {emqx_http_lib, {git, "https://github.com/emqx/emqx_http_lib.git", {tag, "0.5.3"}}},
-    {sasl_auth, "2.3.0"},
+    {sasl_auth, "2.3.2"},
     {jose, {git, "https://github.com/potatosalad/erlang-jose", {tag, "1.11.2"}}},
     {telemetry, "1.1.0"},
     {hackney, {git, "https://github.com/emqx/hackney.git", {tag, "1.18.1-1"}}},
