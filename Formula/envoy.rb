class Envoy < Formula
  desc "Cloud-native high-performance edge/middle/service proxy"
  homepage "https://www.envoyproxy.io/index.html"
  # Switch to a tarball when the following issue is resolved:
  # https://github.com/envoyproxy/envoy/issues/2181
  license "Apache-2.0"
  head "https://github.com/envoyproxy/envoy.git", branch: "main"

  stable do
    url "https://github.com/envoyproxy/envoy.git",
        tag:      "v1.22.2",
        revision: "c919bdec19d79e97f4f56e4095706f8e6a383f1c"

    # Fix build on Apple Silicon which fails on undefined symbol:
    # v8::internal::trap_handler::TryHandleSignal(int, __siginfo*, void*)
    patch do
      url "https://github.com/envoyproxy/envoy/commit/823f81ea8a3c0f792a7dbb0d08422c6a3d251152.patch?full_index=1"
      sha256 "c48ecebc8a63f41f8bf8c4598a6442402470f2f04d20511e1aa3a1f322beccc7"
    end

    # Fix build with GCC in "opt" mode which fails on strict-aliasing rules:
    # type_url_, reinterpret_cast<std::vector<DecodedResourcePtr>&>(decoded_resources),
    patch do
      url "https://github.com/envoyproxy/envoy/commit/aa06f653ed736b428f3ea69900aa864ce4187305.patch?full_index=1"
      sha256 "d05b1519e6d0d78619457deb3d0bed6bb69ee2f095d31b9913cc70c9ee851e80"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c229515a8e2c5e49c12dab26fb4cf452732f17e86c0f7df7b1ec58d16fa42f9f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8779af01643cb05425d1f3ac09b67663ae3002c08a64ca1523cd1ac3f6cce788"
    sha256 cellar: :any_skip_relocation, monterey:       "ccfb037e24539dd688f5d0a35429c26ee3d9ad5a9002df31f905e71070dab8de"
    sha256 cellar: :any_skip_relocation, big_sur:        "adf357907f4d6a12e64b1e6f3c2227bed88e709a75cce4f35553e5b7ea512088"
    sha256 cellar: :any_skip_relocation, catalina:       "8da520a2a769e8306fcc2ca013f598e9f52738c842bf7cccc111132856f1a0bb"
    sha256                               x86_64_linux:   "18853308c3d2cb0b8c0584e597adc5007a68c4a2cd0fe966d45637908c258916"
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
    depends_on "python@3.10" => :build
    depends_on "gcc@9"
  end

  # https://github.com/envoyproxy/envoy/tree/main/bazel#supported-compiler-versions
  fails_with :gcc do
    version "8"
    cause "C++17 support and tcmalloc requirement"
  end
  # GCC 10 build fails at external/com_google_absl/absl/container/internal/inlined_vector.h:448:5:
  # error: '<anonymous>.absl::inlined_vector_internal::Storage<char, 128, std::allocator<char> >::data_'
  # is used uninitialized in this function [-Werror=uninitialized]
  fails_with gcc: "10"
  # GCC 11 build fails at external/org_brotli/c/dec/decode.c:2036:41:
  # error: argument 2 of type 'const uint8_t *' declared as a pointer [-Werror=vla-parameter]
  # Brotli upstream ref: https://github.com/google/brotli/pull/893
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
