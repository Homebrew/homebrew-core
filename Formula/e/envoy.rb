class Envoy < Formula
  desc "Cloud-native high-performance edge/middle/service proxy"
  homepage "https://www.envoyproxy.io/index.html"
  url "https://github.com/envoyproxy/envoy/archive/refs/tags/v1.31.0.tar.gz"
  sha256 "39ba37aed81a9d4988a5736cf558243179f2bf1490843da25687d1aafd9d01c6"
  license "Apache-2.0"
  head "https://github.com/envoyproxy/envoy.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "eafef893f82016ef51251355c42413d7b8a53460793f44222d9845ab7bcfafd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e91a2e11066c3a0c871fa0d94153fe260d71c12ba7db9ea175b19e960e09d002"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc2137c9981786830eb65cac9ed6807bfd6a8eebe7764d59a7f621eef4999b9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af3de81847a5dc7704ac8d2e7e9b2a320653f362f7824e34aa631675ba1983a3"
    sha256 cellar: :any_skip_relocation, sonoma:         "878b3d9a46bba9394b6f2b9b910e83d28ea262bcae3cb5ef4eb6dfb29d7c3c5b"
    sha256 cellar: :any_skip_relocation, ventura:        "a14f5d3f5fef1b495018c639958ec1a5f1737de63f17034e097c92e3b3db9f7f"
    sha256 cellar: :any_skip_relocation, monterey:       "cd1124efc8af189735d10f2cc4d0a66230905ad5ba2d4c6b7ac02ea544e260be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b255d9a8e2d3a99ca8049bac12ba2a094a5b21d7685f77b69b8435914f97ab4"
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

    # GCC/ld.gold had some issues while building envoy so use clang/lld instead
    args << "--config=clang" if OS.linux?

    # clang 18 introduced stricter thread safety analysis
    # https://github.com/envoyproxy/envoy/issues/34233
    args << "--copt=-Wno-thread-safety-reference-return" if DevelopmentTools.clang_version >= 18

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
