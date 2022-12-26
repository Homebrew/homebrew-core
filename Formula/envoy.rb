class Envoy < Formula
  desc "Cloud-native high-performance edge/middle/service proxy"
  homepage "https://www.envoyproxy.io/index.html"
  url "https://github.com/envoyproxy/envoy/archive/refs/tags/v1.24.1.tar.gz"
  sha256 "385e5345e9bc73dcdae311d1df61e16e998860fc958571be9c9b781ad20e14f8"
  license "Apache-2.0"
  head "https://github.com/envoyproxy/envoy.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8b675eb362bcdb1ae559331441af2350900b36323b0b2636bfc443cfb585964"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0edaf0a65899b3d453edbde961c5d4d6eb73e585a690edf19f500aefa1a3baee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88ed056187bc186c7476aa47376a19e4eac0f6e791c43476a35630eae9fadcc3"
    sha256 cellar: :any_skip_relocation, ventura:        "fdc6890ee3d9c68e0946ac502ee7cbfe0ddac76abe88d55b702e4f1fcba817b4"
    sha256 cellar: :any_skip_relocation, monterey:       "055c3088dca7435774fe43b2550c07c9a81c54fce9a31a176c82cf5c75734e73"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad03ba5eb54482ab91de27ec797499809595916fad5edc4ff70ce8cb99769bed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63c2e2d73fa2b79cfc521d357592be6af911a329000ad212730b4ec08824523c"
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
    depends_on "python@3.11" => :build
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
      "#{Formula["python@3.11"].opt_bin}:#{HOMEBREW_PREFIX}/bin:/usr/bin:/bin"
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
    else
      # The clang available on macOS catalina has a warning that isn't clean on v8 code.
      # The warning doesn't show up with more recent clangs, so disable it for now.
      args << "--cxxopt=-Wno-range-loop-analysis"
      args << "--host_cxxopt=-Wno-range-loop-analysis"

      # To supress warning on deprecated declaration on v8 code. For example:
      # external/v8/src/base/platform/platform-darwin.cc:56:22: 'getsectdatafromheader_64'
      # is deprecated: first deprecated in macOS 13.0.
      # https://bugs.chromium.org/p/v8/issues/detail?id=13428.
      # Reference: https://github.com/envoyproxy/envoy/pull/23707.
      args << "--cxxopt=-Wno-deprecated-declarations"
      args << "--host_cxxopt=-Wno-deprecated-declarations"
    end

    # Write the current version SOURCE_VERSION.
    system "python3", "tools/github/write_current_source_version.py",
                      "--skip_error_in_git"

    system Formula["bazelisk"].opt_bin/"bazelisk", "build", *args, "//source/exe:envoy-static.stripped"
    bin.install "bazel-bin/source/exe/envoy-static.stripped" => "envoy"
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
