class Envoy < Formula
  desc "Cloud-native high-performance edge/middle/service proxy"
  homepage "https://www.envoyproxy.io/index.html"
  url "https://github.com/envoyproxy/envoy/archive/refs/tags/v1.37.0.tar.gz"
  sha256 "5cf3a5342bdffe8c1cc28c0afa61a24654d1f781480d3dcc226c81fe41a1e713"
  license "Apache-2.0"
  head "https://github.com/envoyproxy/envoy.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c83d939543e903356e1179eb23ef05577fd9aa273323c51845b191c5a9f8b0c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18a40e57196c60d1596993c55845010caf88ddb83d3b2642e57132ee639c3009"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a668558d84a81f34fdeaaebebc4149e5c4eb83c0ea95fa302793108160c4adf"
    sha256 cellar: :any_skip_relocation, sonoma:        "3032bf14063310000b74c9a579e44579910cfc48d15913777618eb96c9cf2ee6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ce6a57e4b23e4dd96abf74652ff7553e13157695e529e454e96831aea0a61ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7997372e6e874e609fa58344541bc74fd4b4a6fa62a4fc33b4c2ca24257cbb2e"
  end
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bazelisk" => :build
  depends_on "cmake" => :build
  depends_on "go" => :build
  depends_on "libtool" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "wget" => :build
  depends_on xcode: :build
  depends_on "yq" => :build
  # Starting with 1.21, envoy requires a full Xcode installation, not just
  # command-line tools.  See envoyproxy/envoy#16482
  uses_from_macos "llvm" => :build
  uses_from_macos "ncurses" => :build
  uses_from_macos "python" => :build
  on_macos do
    depends_on "aspell" => :build
    depends_on "clang-format" => :build
  end
  on_linux do
    depends_on "lld" => :build
  end

  # https://github.com/envoyproxy/envoy/tree/main/bazel#supported-compiler-versions
  # GCC/ld.gold had some issues while building envoy 1.29 so use clang/lld instead
  fails_with :gcc

  def install
    ENV.remove "PATH", Superenv.shims_path
    ENV.prepend_path "PATH", Formula["llvm"].opt_bin.to_s
    env_path = ENV["PATH"] # "#{HOMEBREW_PREFIX}/bin:/usr/bin:/bin"
    args = %W[
      -c opt
      --curses=no
      --verbose_failures
      --define=wasm=wamr
      --action_env=PATH=#{env_path}
      --host_action_env=PATH=#{env_path}
    ]

    if OS.linux?
      ENV["CC"] = Formula["llvm"].opt_bin/"clang"
      ENV["CXX"] = Formula["llvm"].opt_bin/"clang++"
      args << "--action_env=CC=#{ENV["CC"]}"
      args << "--action_env=CXX=#{ENV["CXX"]}"
      args << "--host_action_env=CC=#{ENV["CC"]}"
      args << "--host_action_env=CXX=#{ENV["CXX"]}"
    end

    # Disable external LLVM toolchain download - use local toolchain
    # args << "--repo_env=BAZEL_DO_NOT_DETECT_CPP_TOOLCHAIN=1"

    # On macOS, ensure we use the system linker consistently
    if OS.mac?
      args << "--linkopt=-L#{Formula["llvm"].opt_lib}"
      args << "--linkopt=-Wl,-rpath,#{Formula["llvm"].opt_lib}"
    end

    # Use clang-local config for non-standard LLVM locations (Homebrew)

    # Workaround to build with Clang 20 until envoy uses newer dd-trace-cpp (with newer nlohmann-json)
    # https://github.com/DataDog/dd-trace-cpp/commit/a7d71b5e0599125d5957f7b8d3d56f0bcc6ae485
    args << "--copt=-Wno-deprecated-literal-operator"
    # Workaround to build with Clang 21, upstream also ignores this warning
    # https://github.com/google/cel-cpp/blob/439003a0016ed7ace068cffdf494357a3f75e3b2/common/values/value_variant.h#L735-L743
    # args << "--copt=-Wno-nontrivial-memcall"

    # Make Bazel/toolchains_llvm use Homebrew's LLVM instead of trying to download a prebuilt

    args << "--copt=-Wno-nullability-completeness" if OS.linux? || DevelopmentTools.clang_build_version >= 1700

    # llvm_prefix = Formula["llvm"].opt_prefix
    args << "--config=clang-local" if OS.linux?
    args << "--config=macos" if OS.mac?
    # Ensure Bazel can find yq during WORKSPACE evaluation
    output_base = Utils.safe_popen_read("bazel", "info", "output_base").chomp
    odie "Failed to determine bazel output_base" if output_base.empty?
    yq_bin = Formula["yq"].opt_bin/"yq"
    platform_suffix = "yq_#{OS.kernel_name.downcase}_#{Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch}"
    ["yq", platform_suffix].each do |suffix|
      dir = File.join(output_base, "external", suffix)
      mkdir_p(dir)
      ln_sf(yq_bin, File.join(dir, "yq"))
    end

    inreplace "bazel/toolchains.bzl" do |s|
      # TODO: dont hardcode the version. use from formula.
      s.gsub!(/llvm_version = "[\w.?]*",/, 'llvm_version = "20.1.7",')
    end

    # Write the current version SOURCE_VERSION.
    system "python3", "tools/github/write_current_source_version.py", "--skip_error_in_git"

    # system "bazel", "build", "-c", "opt", "envoy"
    system "bazel", "build", *args, "//source/exe:envoy-static.stripped"
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
