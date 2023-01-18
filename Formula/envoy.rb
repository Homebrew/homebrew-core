class Envoy < Formula
  desc "Cloud-native high-performance edge/middle/service proxy"
  homepage "https://www.envoyproxy.io/index.html"
  url "https://github.com/envoyproxy/envoy/archive/refs/tags/v1.25.0.tar.gz"
  sha256 "81e6cecfb22d52b5d81bad54271d0febeb27dd2e79847315228fe0560ea83854"
  license "Apache-2.0"
  head "https://github.com/envoyproxy/envoy.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8884c61777053dace6c9d72c689efb7b985ae24a4315ec61a8d86e49981a7ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "745f7a1a124bfc02be2bf6b6434049c904bbc38abd3dda69c3ef738169468de7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "616703b5342050555532080fe98f12f57f8fcdff403e390d828f19ad88ad83db"
    sha256 cellar: :any_skip_relocation, ventura:        "29d3129e51b2d6c06cd0213d34bc0dab46098224e7e12e13fc88f951c18c2060"
    sha256 cellar: :any_skip_relocation, monterey:       "c851e41349c8586834d6f0976a6aab6562d7910b99d6e49e8cb785e4883266ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "774a1c8b479942cf41bf400f074a51e5add628e6bd72141da65e452a13cf0dad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8efb10dce3c4963f6767d3f26e037b5bea3de29af428544984f337b9f62e5657"
  end

  depends_on "automake" => :build
  depends_on "bazelisk" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "ninja" => :build
  # Starting with 1.21, envoy requires a full Xcode installation, not just
  # command-line tools. See envoyproxy/envoy#16482
  depends_on xcode: :build
  depends_on macos: :catalina

  uses_from_macos "python" => :build

  on_macos do
    depends_on "coreutils" => :build
  end

  # https://github.com/envoyproxy/envoy/tree/main/bazel#supported-compiler-versions
  fails_with :gcc do
    version "8"
    cause "C++17 support and tcmalloc requirement"
  end

  def install
    env_path = "#{HOMEBREW_PREFIX}/bin:/usr/bin:/bin"
    args = %W[
      --compilation_mode=opt
      --curses=no
      --verbose_failures
      --action_env=PATH=#{env_path}
      --host_action_env=PATH=#{env_path}
    ]

    if OS.linux?
      # Build fails with GCC 10+ at external/com_google_absl/absl/container/internal/inlined_vector.h:448:5:
      # error: '<anonymous>.absl::inlined_vector_internal::Storage<char, 128, std::allocator<char> >::data_'
      # is used uninitialized in this function [-Werror=uninitialized]
      # Try to remove in a release that uses a newer abseil
      args << "--cxxopt=-Wno-uninitialized"
      args << "--host_cxxopt=-Wno-uninitialized"
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
    system "python3", "tools/github/write_current_source_version.py", "--skip_error_in_git"

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
