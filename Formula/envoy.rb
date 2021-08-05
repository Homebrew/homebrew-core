class Envoy < Formula
  desc "Cloud-native high-performance edge/middle/service proxy"
  homepage "https://www.envoyproxy.io/index.html"
  url "https://github.com/envoyproxy/envoy.git",
      tag:      "v1.19.0",
      revision: "68fe53a889416fd8570506232052b06f5a531541"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "ff325521cbdf6b990e33924fe345d55a1fc65286db0b1484557f02a10e0954c0"
    sha256 cellar: :any_skip_relocation, catalina:     "b0db4468a8794a6a7de0132b64029504921fd8eee9c7f3b224f4461bc5e515f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f4f1c780aeaef9ef6caf889591c98c1b610df2e8b3a6456dcefa979f879408a7"
  end

  depends_on "automake" => :build
  depends_on "bazelisk" => :build
  depends_on "cmake" => :build
  depends_on "coreutils" => :build
  depends_on "go" => :build
  depends_on "libtool" => :build
  depends_on "ninja" => :build
  depends_on macos: :catalina

  on_linux do
    # GCC added as a test dependency to work around Homebrew issue. Otherwise `brew test` fails.
    # CompilerSelectionError: envoy cannot be built with any available compilers.
    depends_on "gcc@9" => [:build, :test]
    depends_on "python@3.9" => :build
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

  # Work around xcode 12 incompatibility until envoyproxy/envoy#17393
  patch do
    url "https://github.com/envoyproxy/envoy/commit/3b49166dc0841b045799e2c37bdf1ca9de98d5b1.patch?full_index=1"
    sha256 "e65fe24a29795606ea40aaa675c68751687e72911b737201e9714613b62b0f02"
  end

  def install
    env_path = "#{HOMEBREW_PREFIX}/bin:/usr/bin:/bin"
    on_linux do
      env_path = "#{Formula["python@3.9"].opt_libexec}/bin:#{env_path}"
    end
    args = %W[
      --compilation_mode=opt
      --curses=no
      --show_task_finish
      --verbose_failures
      --action_env=PATH=#{env_path}
      --host_action_env=PATH=#{env_path}
    ]

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
