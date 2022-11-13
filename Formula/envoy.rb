class Envoy < Formula
  desc "Cloud-native high-performance edge/middle/service proxy"
  homepage "https://www.envoyproxy.io/index.html"
  url "https://github.com/envoyproxy/envoy/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "31a81841447fbb51589a198d8e8998f2b8ad1fff4921e017fa37691015b3a9f9"
  license "Apache-2.0"
  head "https://github.com/envoyproxy/envoy.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9d32dadfa5ea47cc5691685ff41675d8d3a196bc609c6696643789dc768867a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "760f8e5fdc6f9331689a4c1159d92a89b3474a40c2fea2cadf113f1409b3962b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29f1920e697f3e17bd42d11ca99e1f1bf1086b0488f06cbd6c45eadb0b635e0d"
    sha256 cellar: :any_skip_relocation, monterey:       "ab84476a2ae6bbd1b47f64fe1a1d93aed5ef003775a50b8bbaf9b6b28c018e45"
    sha256 cellar: :any_skip_relocation, big_sur:        "f85ffd2b5e8761e379cddf3f1aa960b06cd6b6f6397610e5ed74a29007d4fa83"
    sha256 cellar: :any_skip_relocation, catalina:       "f2b1f7a4598d8721a08da713e59723ca0f26b520d534656c47f3ffd1e3516038"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dba5897716b8dad485eb0e290f475f7bd5e567f92a7972af7e14650628618ae1"
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

  # Remove this when the tagged release archive has "tools/github/write_current_source_version.py".
  # Reference: https://github.com/envoyproxy/envoy/blob/main/bazel/README.md#building-from-a-release-tarball.
  resource "write_current_source_version.py" do
    url "https://raw.githubusercontent.com/envoyproxy/envoy/3ea63d73407f5af8992e20e1bf0fb4b481b71d13/tools/github/write_current_source_version.py"
    sha256 "89f90657983d4b21b29a710503125f90fee3af3a3a93a48fefc1d7296a4ce5ab"
  end

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

    # Remove this when the tagged release archive has "tools/github/write_current_source_version.py".
    # Reference: https://github.com/envoyproxy/envoy/blob/main/bazel/README.md#building-from-a-release-tarball.
    write_current_source_version_tool = "tools/github/write_current_source_version.py"
    unless File.file?(write_current_source_version_tool)
      resource("write_current_source_version.py").stage do
        cp "write_current_source_version.py", "#{buildpath}/#{write_current_source_version_tool}"
      end
    end

    # Write the current version SOURCE_VERSION.
    system "python3", write_current_source_version_tool, "--skip_error_in_git"

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
