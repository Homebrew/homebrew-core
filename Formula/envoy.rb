class Envoy < Formula
  desc "Cloud-native high-performance edge/middle/service proxy"
  homepage "https://www.envoyproxy.io/index.html"
  # Switch to a tarball when the following issue is resolved:
  # https://github.com/envoyproxy/envoy/issues/2181
  license "Apache-2.0"
  head "https://github.com/envoyproxy/envoy.git", branch: "main"

  stable do
    url "https://github.com/envoyproxy/envoy.git",
        tag:      "v1.22.1",
        revision: "ae27fb5280d30e1400b7e9c9cbd448bfcd4ad9f5"

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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc1cf0df4ac0a006ae09d4b6334714fa95da8f49537f81c99a73ab351379bab9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d45e9366b2a1634682bf75045797df394ff8344da581a2da921d590c7258648"
    sha256 cellar: :any_skip_relocation, monterey:       "90ba116ea4a5d21c444a6f6f4b31676f7767602a5ce0cd830fd59c79ef02c77e"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e02b448afbc376f19ac28d0acb5cc4287474edbb62b6528e7805b124c6b98ac"
    sha256 cellar: :any_skip_relocation, catalina:       "07e363dfa5215b04e8255a917498567741c4af4fde19823e5bdb282990b2d90d"
    sha256                               x86_64_linux:   "17bd5c7119d92142b6da277574c13da07ad149f96af044a988e9a2f769eb9b4d"
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
