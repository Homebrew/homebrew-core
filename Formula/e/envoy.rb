class Envoy < Formula
  desc "Cloud-native high-performance edge/middle/service proxy"
  homepage "https://www.envoyproxy.io/index.html"
  url "https://github.com/envoyproxy/envoy/archive/refs/tags/v1.30.1.tar.gz"
  sha256 "8f0f34d4a2b2f07ffcd898d62773dd644a5944859e0ed2cdf20cd381d6ea7f9d"
  license "Apache-2.0"
  head "https://github.com/envoyproxy/envoy.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ae57ea855d6e5a7a2fdb35d882bd829788c5e46eb04d9814bba0791d6da2b10"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ad1ffe06849069c56ac2c764156144c0b2a0c4e86ea8bcac14ca413122b1e5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "461fe8d0ceac27a326c1d13a459fee8a987db8a422e6b3d767936b37737c0d40"
    sha256 cellar: :any_skip_relocation, sonoma:         "4100f3a74a081767a7919a63de0cd2c69e7c298eaf2b2205d4816b5c9f13ba0e"
    sha256 cellar: :any_skip_relocation, ventura:        "0539e51a7582f8361d23383385bbfba02056139905e0532927ef3f8903e85cb0"
    sha256 cellar: :any_skip_relocation, monterey:       "055602c93dc9c90d480516f929eef303bc4769c8c8a572322862c5696dbd00ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9bddbb9b0adc226b58fc707b9b87d27691acdc001213d2614dc5a55b14b8951"
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
    ]

    # Work around build issue with Xcode 15.3 / LLVM 16+
    # https://github.com/envoyproxy/envoy/issues/33225
    # https://gitlab.freedesktop.org/pkg-config/pkg-config/-/issues/81
    args << "--host_action_env=CFLAGS=-Wno-int-conversion"

    # GCC/ld.gold had some issues while building envoy so use clang/lld instead
    args << "--config=clang" if OS.linux?

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
