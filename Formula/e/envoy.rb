class Envoy < Formula
  desc "Cloud-native high-performance edge/middle/service proxy"
  homepage "https://www.envoyproxy.io/index.html"
  url "https://github.com/envoyproxy/envoy/archive/refs/tags/v1.33.2.tar.gz"
  sha256 "e54d444a8d4197c1dca56e7f6e7bc3b7d83c1695197f5699f62e250ecbece169"
  license "Apache-2.0"
  head "https://github.com/envoyproxy/envoy.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e150c63d6060aceeafe7a53ad19af6e849e5698b0c4efd21297611c9681963b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f719f8850ccd293a12bb1da640773197dcb3b08013f900f509dd12566720884c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4ddd7d90ee1f9d92e14bbe9cd1ae85ea4c7675c771ca990a9cf325327f9a611c"
    sha256 cellar: :any_skip_relocation, sonoma:        "bee7826424b1d75e9617c88530ae01a127bc52321aca6738b6e40eb095dc2a88"
    sha256 cellar: :any_skip_relocation, ventura:       "879dac6ca9ca1bd679de9180c96691439188b1ed5eb84b5cb66c9260f538afcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c0d398820c2ffd6cb4f2472f8b3029f874546c0eb6648295699e23668a39b8d"
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

  uses_from_macos "llvm" => :build
  uses_from_macos "python" => :build

  on_macos do
    depends_on "coreutils" => :build
  end

  on_linux do
    depends_on "lld" => :build
  end

  # https://github.com/envoyproxy/envoy/tree/main/bazel#supported-compiler-versions
  # GCC/ld.gold had some issues while building envoy 1.29 so use clang/lld instead
  fails_with :gcc

  def install
    env_path = "#{HOMEBREW_PREFIX}/bin:/usr/bin:/bin"
    args = %W[
      --compilation_mode=opt
      --curses=no
      --verbose_failures
      --action_env=PATH=#{env_path}
      --host_action_env=PATH=#{env_path}
      --define=wasm=disabled
    ]

    if OS.linux?
      # GCC/ld.gold had some issues while building envoy so use clang/lld instead
      args << "--config=clang"

      # clang 18 introduced stricter thread safety analysis. Remove once release that supports clang 18
      # https://github.com/envoyproxy/envoy/issues/37911
      args << "--copt=-Wno-thread-safety-reference-return"

      # Workaround to build with Clang 19 until envoy uses newer tcmalloc
      # https://github.com/google/tcmalloc/commit/a37da0243b83bd2a7b1b53c187efd4fbf46e6e38
      args << "--copt=-Wno-unused-but-set-variable"

      # Workaround to build with Clang 19 until envoy uses newer grpc
      # https://github.com/grpc/grpc/commit/e55f69cedd0ef7344e0bcb64b5ec9205e6aa4f04
      args << "--copt=-Wno-missing-template-arg-list-after-template-kw"
    end

    # Write the current version SOURCE_VERSION.
    system "python3", "tools/github/write_current_source_version.py", "--skip_error_in_git"

    system Formula["bazelisk"].opt_bin/"bazelisk", "build", *args, "//source/exe:envoy-static.stripped"
    bin.install "bazel-bin/source/exe/envoy-static.stripped" => "envoy"
    pkgshare.install "configs"
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
