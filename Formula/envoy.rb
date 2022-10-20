class Envoy < Formula
  desc "Cloud-native high-performance edge/middle/service proxy"
  homepage "https://www.envoyproxy.io/index.html"
  # Switch to a tarball when the following issue is resolved:
  # https://github.com/envoyproxy/envoy/issues/2181
  license "Apache-2.0"
  head "https://github.com/envoyproxy/envoy.git", branch: "main"

  stable do
    url "https://github.com/envoyproxy/envoy.git",
        tag:      "v1.23.1",
        revision: "edd69583372955fdfa0b8ca3820dd7312c094e46"

    # Fix build failure on macOS 10.15 due to error at
    # source/extensions/filters/http/file_system_buffer/filter.cc:402:53:
    # error: no viable constructor or deduction guide for deduction of template arguments of 'weak_ptr'.
    # For the next v1.23.x release, this can be removed after https://github.com/envoyproxy/envoy/pull/23177
    # is merged.
    patch do
      url "https://github.com/envoyproxy/envoy/commit/68aa00067bbeb7aaf13599f75e54e8837cfb13ef.patch?full_index=1"
      sha256 "0efbefd5cab5ada6c46845535644339733c4198ac21582401ba038605bc4ed5b"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7bf1c8a8edd41908a662bcf5f4d12fe097635c16a5274de321e5e632a72ec4f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f63c8c45373a38df81fe854f6064c0c4bcecd0c8b5cadf0bf5408999b29e6aac"
    sha256 cellar: :any_skip_relocation, monterey:       "3aaa744a59e5ed4dd1b316ec020fdaaa03ea267b7aa33d3a7ce25b0031d1c6a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd38a660c9d1623b968e7c13d9f250b885488381a3cf866358a9d960d4dceb01"
    sha256 cellar: :any_skip_relocation, catalina:       "e2240ae23e6351058022840344b0c30aee820977eec71acd29a641338ea4991d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ce1642222af2cb38ea97a5da78b71b8d1ea0ad1aa4930284b07d23252db247e"
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
    depends_on "gcc@9" => [:build, :test] # Use host/Homebrew GCC runtime libraries.
    depends_on "python@3.10" => :build
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
