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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "122977e8eee980aab6b9d5fa2ba9fc1e58f831e68345e417e7fdc52df554d7a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "78d13f1e2a098f849805bf575c53e52dd452ae45c8fa2134e93941c7bcdb7e89"
    sha256 cellar: :any_skip_relocation, monterey:       "97dde181e8691fb7594cdf1d788049d9e9e658128fd912128eb2be31ccbe0b9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "55c03e83374c3637254dc03c3ecf67833861cd6f6ef013d8c9b91d6b5d0a48ab"
    sha256 cellar: :any_skip_relocation, catalina:       "6ec9fb982745c52765ec8cb02f9ea7bceb53ff821e30100e45d4cbb2b9587c38"
    sha256                               x86_64_linux:   "7add4d2d423ab7ab170c5ded6e8681a6b7c1b6806ecb4ef18f772f3cc785e121"
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
