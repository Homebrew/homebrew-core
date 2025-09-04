class Envoy < Formula
  desc "Cloud-native high-performance edge/middle/service proxy"
  homepage "https://www.envoyproxy.io/index.html"
  url "https://github.com/envoyproxy/envoy/archive/refs/tags/v1.35.2.tar.gz"
  sha256 "eaaa169ef5ce15c5448d1a73eda3ef50c71c5c77cc6ff152426d84a3cea3f791"
  license "Apache-2.0"
  head "https://github.com/envoyproxy/envoy.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb40ffa5e71399dbc43ed0e485f62f280b782c5b20d0c72f4381dc0f046a0892"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36f899e9296d2fc4869ea86291be483585bcae9d293c758ec8f94c0397645fe3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "65c00855759cfcee097e9ffeed90b48d820fa7c79a3ed94aa44b7a214e5f9161"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2758ce92ba0d750e67870d2171eea34ad91067cf33df772b65ec92421a211d7"
    sha256 cellar: :any_skip_relocation, ventura:       "619b85017d4668440564cc340b1a02667508af6b536f21bf4dac5be4df50441a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47b623c77ce5e3e9149dad4886109144e7ea280eb06c74c587e6be186744e09d"
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
