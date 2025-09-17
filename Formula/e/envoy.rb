class Envoy < Formula
  desc "Cloud-native high-performance edge/middle/service proxy"
  homepage "https://www.envoyproxy.io/index.html"
  url "https://github.com/envoyproxy/envoy/archive/refs/tags/v1.35.3.tar.gz"
  sha256 "e0ce5722eaf82a9663f86c90c6351319096bce15fee72de545813b82be3add04"
  license "Apache-2.0"
  head "https://github.com/envoyproxy/envoy.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca3b13a35c4694ba817ae8e3493900a3a1bf80b55aa4d7d97c0f10d6258cabd5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "960db95ad8234d221bec4594d5c14880ffd99c1b38c7b33dcfc82b2cef7a16be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07e32107e2246c7cba2e451f87629743ea006337c791d84e8579e89999bc0cc2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "529a4b03f14bedffcfdfc8c739c43f10858098560f815da977cd481d18183141"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e818f087fb2104e2c317c6321215cc09bc97c0ecb291036a275de7c7f625127"
    sha256 cellar: :any_skip_relocation, ventura:       "13c64c6a70aa87f4df7c3dd87254745fe800e26aeb545ef4e55ab58769b76781"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "362ea90dc87ede34765d6433de6ea26bf6a2b46fc287c7cf29662902c553b3e9"
  end

  depends_on "automake" => :build
  depends_on "bazelisk" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "ninja" => :build
  # Starting with 1.21, envoy requires a full Xcode installation, not just
  # command-line tools. See envoyproxy/envoy#16482
  depends_on xcode: :build

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
      --define=wasm=wamr
    ]

    if OS.linux?
      # GCC/ld.gold had some issues while building envoy so use clang/lld instead
      args << "--config=clang-common"

      # Workaround to build with Clang 20 until envoy uses newer dd-trace-cpp (with newer nlohmann-json)
      # https://github.com/DataDog/dd-trace-cpp/commit/a7d71b5e0599125d5957f7b8d3d56f0bcc6ae485
      args << "--copt=-Wno-deprecated-literal-operator"
    end

    # Workaround to build with Xcode 16.3 / Clang 19
    args << "--copt=-Wno-nullability-completeness" if OS.linux? || DevelopmentTools.clang_build_version >= 1700

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
