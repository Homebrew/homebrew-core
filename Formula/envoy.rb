class Envoy < Formula
  desc "Cloud-native high-performance edge/middle/service proxy"
  homepage "https://www.envoyproxy.io/index.html"
  # Switch to a tarball when the following issue is resolved:
  # https://github.com/envoyproxy/envoy/issues/2181
  url "https://github.com/envoyproxy/envoy.git",
      tag:      "v1.21.1",
      revision: "af50070ee60866874b0a9383daf9364e884ded22"
  license "Apache-2.0"
  head "https://github.com/envoyproxy/envoy.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd040355dcf85a5329f4b4183f8e2349375f638c229846ecd41a3196792f6f1d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c79e20485986dcb6a808e285e80895fc049d2006451b043a52364f7bd12c3472"
    sha256 cellar: :any_skip_relocation, monterey:       "9c183ed8572762a704cf81e9da4996d9120a26edc7e7f71692fddf9b953c1820"
    sha256 cellar: :any_skip_relocation, big_sur:        "e52e76c005d586a18399dc7e560179554bfdeb58977e09c0db7c3a2cca4c74c5"
    sha256 cellar: :any_skip_relocation, catalina:       "8cb1b2dc93193366e72763619811e22bd35cfd27e4bfd81a0501888b42c460ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fad41038273bfb42e45949d8ba1a6a1467a2b541497df4782396bdc150a3828d"
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
      --show_task_finish
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
