class Envoy < Formula
  desc "Cloud-native high-performance edge/middle/service proxy"
  homepage "https://www.envoyproxy.io/index.html"
  # Switch to a tarball when the following issue is resolved:
  # https://github.com/envoyproxy/envoy/issues/2181
  url "https://github.com/envoyproxy/envoy.git",
      tag:      "v1.21.2",
      revision: "dc7f46eb44e54d5646301aa5ab4ba01f662fdf75"
  license "Apache-2.0"
  head "https://github.com/envoyproxy/envoy.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89354fae8d255f7c9c96d577201a17146fdf6d3869691fba0f191231504f9f77"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c10c36d88c1be8a6c658da6060364b667b543e35bd9055619d9c98bd93ed0dc8"
    sha256 cellar: :any_skip_relocation, monterey:       "3674bd7e56db7d7e7ae6125c34ac258e26957015c2ebaa837218df1e169f3b94"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b1aac9989d81199ebeeac66bf38205554019892b52b214b76a34dabe61695b0"
    sha256 cellar: :any_skip_relocation, catalina:       "410c2fba36a9efc5b0d1c340fb80c95f7ce3cddcc75ac249dd603eb05491efa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f40044f44e01006b40c979a3954c11c2a075aabd96aaf4fa13b3c69717303bf"
  end

  depends_on "automake" => :build
  depends_on "bazelisk" => :build
  depends_on "cmake" => :build
  depends_on "coreutils" => :build
  depends_on "libtool" => :build
  depends_on "ninja" => :build
  # Starting with 1.21, envoy requires a full Xcode installation, not just
  # command-line tools. See envoyproxy/envoy#16482
  depends_on xcode: :build
  depends_on macos: :catalina

  on_linux do
    # GCC added as a test dependency to work around Homebrew issue. Otherwise `brew test` fails.
    # CompilerSelectionError: envoy cannot be built with any available compilers.
    depends_on "gcc@9" => [:build, :test]
    depends_on "python@3.10" => :build
  end

  # https://github.com/envoyproxy/envoy/tree/main/bazel#supported-compiler-versions
  fails_with gcc: "5"
  fails_with gcc: "6"
  # GCC 10 build fails at external/com_google_absl/absl/container/internal/inlined_vector.h:469:5:
  # error: '<anonymous>.absl::inlined_vector_internal::Storage<char, 128, std::allocator<char> >::data_'
  # is used uninitialized in this function [-Werror=uninitialized]
  fails_with gcc: "10"
  # GCC 11 build fails at external/boringssl/src/crypto/curve25519/curve25519.c:503:57:
  # error: argument 2 of type 'const uint8_t[32]' with mismatched bound [-Werror=array-parameter=]
  fails_with gcc: "11"

  def install
    env_path = if OS.mac?
      "#{HOMEBREW_PREFIX}/bin:/usr/bin:/bin"
    else
      "#{Formula["python@3.10"].opt_bin}:#{HOMEBREW_PREFIX}/bin:/usr/bin:/bin"
    end
    args = %W[
      --compilation_mode=opt
      --curses=no
      --verbose_failures
      --action_env=PATH=#{env_path}
      --host_action_env=PATH=#{env_path}
    ]

    if OS.linux?
      # Disable extension `tcp_stats` which requires Linux headers >= 4.6
      # It's a directive with absolute path `#include </usr/include/linux/tcp.h>`
      args << "--//source/extensions/transport_sockets/tcp_stats:enabled=false"
    end

    system Formula["bazelisk"].opt_bin/"bazelisk", "build", *args, "//source/exe:envoy-static"
    bin.install "bazel-bin/source/exe/envoy-static" => "envoy"
    pkgshare.install "configs", "examples"
  end

  test do
    port = free_port

    cp pkgshare/"configs/envoyproxy_io_proxy.yaml", testpath/"envoy.yaml"
    inreplace "envoy.yaml" do |s|
      s.gsub! "port_value: 9901", "port_value: #{port}"
      s.gsub! "port_value: 10000", "port_value: #{free_port}"
    end

    fork do
      exec bin/"envoy", "-c", "envoy.yaml"
    end
    sleep 10
    assert_match "HEALTHY", shell_output("curl -s 127.0.0.1:#{port}/clusters?format=json")
  end
end
