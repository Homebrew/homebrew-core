class Envoy < Formula
  desc "Cloud-native high-performance edge/middle/service proxy"
  homepage "https://www.envoyproxy.io/index.html"
  license "Apache-2.0"
  head "https://github.com/envoyproxy/envoy.git", branch: "main"

  stable do
    url "https://github.com/envoyproxy/envoy/archive/refs/tags/v1.33.0.tar.gz"
    sha256 "fd726135761ea163f0312d49960c602c9b4fcb78ca3c36600975fed16e0787c4"

    # Backport disabling libcurl docs to fix build. Remove in the next release.
    patch do
      url "https://github.com/envoyproxy/envoy/commit/ae6cb3254cbf98999993d0120d289a207a57f825.patch?full_index=1"
      sha256 "a5c25bad6884f382909036ac9e8c812c5d3ba3104f2f1d24f5035acf705b0d74"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "691cd0a607d8d87f7dfa64976aedcd779d2061d94d0b88b2253f98cfdc898f33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "494f6f9f2e19abfef167a8c16d6e37a2365046f3a11d798f35dcdc8d4f449760"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae500a19266c143b27ab88c463a923919692b2767d235bfad61c1f51a37e6a51"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fc6ababc39170ab0e175cf542955f95e5f927bdcfc53098c1048467847bf388"
    sha256 cellar: :any_skip_relocation, ventura:       "6e134fd52fad3fdec6293dac2135003ba3e458f0b2737ad16d4a6e544d43eeef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b56276639ae42c6de00e30caf68e8c29d79565b0cee17a477b1f03ee680ec23d"
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
