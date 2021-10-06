class Envoy < Formula
  desc "Cloud-native high-performance edge/middle/service proxy"
  homepage "https://www.envoyproxy.io/index.html"
  # Switch to a tarball when the following issue is resolved:
  # https://github.com/envoyproxy/envoy/issues/2181
  url "https://github.com/envoyproxy/envoy.git",
      tag:      "v1.20.0",
      revision: "96701cb24611b0f3aac1cc0dd8bf8589fbdf8e9e"
  license "Apache-2.0"

  # Apple M1/arm64 is pending envoyproxy/envoy#16482
  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "5d242c76931465e1bebc4ac62742bcdd68a42334679cc69f8c058e1f7b4147a1"
    sha256 cellar: :any_skip_relocation, catalina:     "48e53aac4dc4b8c7603141b711730427a5ca94ce4d3e3ce572c1c01cd96ad9f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "deab2f6221196615ee138102d6496f849b85a11880fcf5b783ec30e07ed78419"
  end

  depends_on "automake" => :build
  depends_on "bazelisk" => :build
  depends_on "cmake" => :build
  depends_on "coreutils" => :build
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

  def install
    env_path = if OS.mac?
      "#{HOMEBREW_PREFIX}/bin:/usr/bin:/bin"
    else
      "#{Formula["python@3.9"].opt_libexec}/bin:#{HOMEBREW_PREFIX}/bin:/usr/bin:/bin"
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
