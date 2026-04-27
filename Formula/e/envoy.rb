class Envoy < Formula
  desc "Cloud-native high-performance edge/middle/service proxy"
  homepage "https://www.envoyproxy.io/index.html"
  url "https://github.com/envoyproxy/envoy/archive/refs/tags/v1.38.0.tar.gz"
  sha256 "dfc86489802788f053956d9d1ad5c1fef5d982eddf7a9df69a0184a3a1ac4184"
  license "Apache-2.0"
  head "https://github.com/envoyproxy/envoy.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5a42a61bf6e211b7391bb79d66c4b72a759b113b2b5568d60cf7feb2bce4097"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d8ff9b7ad9edee2ef92144328cf697f69373ab022a178c21eef511db424b6e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4c8fbce8679ed2728a36428a35db4d6fd118de84e1ce8ea919bf147385c42e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "da740563a4a283764bfce68f22c8887834a0f8c0f926bf90a31d0a1015763457"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4c48997c3e784e8132a2514c329c20b7b93520e55ed4941b45f76132bf00b8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74283a702e21898ea8fcb816a81d2c90b9cfa7a04294096e4ddef3c18b7087c7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bazelisk" => :build
  depends_on "cmake" => :build
  depends_on "go" => :build
  depends_on "libtool" => :build
  depends_on "llvm@18" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "wget" => :build
  depends_on xcode: :build
  depends_on "yq" => :build

  uses_from_macos "ncurses" => :build
  uses_from_macos "python" => :build

  on_macos do
    depends_on "aspell" => :build
    depends_on "clang-format" => :build
  end

  on_linux do
    depends_on "libxml2" => :build
    depends_on "lld" => :build
  end

  def bazelisk
    Formula["bazelisk"].opt_bin/"bazelisk"
  end

  def llvm_formula
    Formula["llvm@18"]
  end

  def install
    ENV.remove "PATH", "#{Superenv.shims_path}:"

    # rules_foreign_cc CMake try-compile can pick GNU ld from PATH and fail to link
    # against Envoy's configured sysroot/toolchain. Keep clang/llvm tools but drop binutils.
    ENV.remove "PATH", ":#{Formula["binutils"].opt_bin}" if OS.linux?
    env_path = ENV["PATH"]

    # Drop hickory DNS: its rust SDK pulls in mockall (incompatible with macOS)
    # and references `@llvm_toolchain_llvm` labels that aren't registered when
    # LLVM is injected via `BAZEL_LLVM_PATH`.
    inreplace "source/extensions/extensions_build_config.bzl",
              /^\s*"envoy\.network\.dns_resolver\.hickory":.*\n/, ""

    args = %W[
      --noenable_bzlmod
      --@envoy//bazel/foreign_cc:parallel_builds
      --compilation_mode=opt
      --curses=no
      --noincompatible_strict_action_env
      --verbose_failures
      --action_env=PATH=#{env_path}
      --host_action_env=PATH=#{env_path}
      --define=wasm=wamr
      --repository_cache=#{HOMEBREW_CACHE}/envoy-repository-cache
      --jobs=#{ENV.make_jobs}
    ]
    bazel_args = %W[
      --output_user_root=#{buildpath}/user_root
    ]

    if OS.linux?
      args.push(
        "--config=clang-local",
        "--repo_env=BAZEL_DO_NOT_DETECT_CPP_TOOLCHAIN=1",
        "--copt=-Wno-deprecated-literal-operator",
        "--copt=-Wno-unknown-warning-option",
        "--copt=-Wno-nontrivial-memcall",
        "--copt=-Wno-nontrivial-memaccess",
        "--copt=-Wno-nonportable-include-path",
        "--strategy=BootstrapGNUMake=standalone",
        "--strategy=BootstrapPkgConfig=standalone",
      )
    else
      args << "--config=macos"
    end

    # Workaround to build with Xcode 16.3 / Clang 19.
    args << "--copt=-Wno-nullability-completeness" if OS.linux? || DevelopmentTools.clang_build_version >= 1700

    # Envoy v1.37.0 expects a specific LLVM layout and tools, but Homebrew paths differ.
    # Stage a local toolchain root matching upstream expectations.
    llvm_path = buildpath/"llvm-toolchain"
    llvm = llvm_formula.opt_prefix
    (llvm_path/"bin").mkpath
    (llvm_path/"lib").mkpath
    (llvm/"bin").children.each { |path| ln_sf path, llvm_path/"bin"/path.basename }
    (llvm/"lib").children.each { |path| ln_sf path, llvm_path/"lib"/path.basename }
    ln_sf llvm/"include", llvm_path/"include"
    ln_sf llvm/"libexec", llvm_path/"libexec"
    ln_sf llvm/"share", llvm_path/"share"

    if OS.mac?
      # rules_foreign_cc expects "libtool" for AR on Darwin.
      ln_sf which("libtool"), llvm_path/"bin/libtool"
    end
    ln_sf Formula["libtool"].opt_bin/"glibtool", llvm_path/"bin/glibtool"
    ENV["BAZEL_LLVM_PATH"] = llvm_path

    # clang-common links these archives in foreign_cc bootstrap; provide them from brewed llvm.
    if OS.linux?
      libdir = llvm_formula.opt_lib
      ln_sf libdir/"libc++.a", llvm_path/"lib/libc++.a" if (libdir/"libc++.a").exist?
      ln_sf libdir/"libc++abi.a", llvm_path/"lib/libc++abi.a" if (libdir/"libc++abi.a").exist?

      args << "--linkopt=-L#{llvm_path}/lib"
      args << "--host_linkopt=-L#{llvm_path}/lib"
    end

    output_base = Utils.safe_popen_read(
      bazelisk, *bazel_args, "info", "output_base"
    ).chomp
    odie "Failed to determine bazel output_base" if output_base.empty?
    yq_bin = Formula["yq"].opt_bin/"yq"
    platform_suffix = "yq_#{OS.kernel_name.downcase}_#{Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch}"
    ["yq", platform_suffix].each do |suffix|
      dir = Pathname(output_base)/"external"/suffix
      dir.mkpath
      ln_sf yq_bin, dir/"yq"
    end

    # Write the current version SOURCE_VERSION.
    system "python3", "tools/github/write_current_source_version.py", "--skip_error_in_git",
           "--github_api_token_env_name=HOMEBREW_GITHUB_API_TOKEN"

    system bazelisk, *bazel_args, "build", *args, "//source/exe:envoy-static.stripped"
    bin.install "bazel-bin/source/exe/envoy-static.stripped" => "envoy"
    # Copy the configs directory to the pkgshare directory.
    pkgshare.install "configs"
  end

  test do
    port = free_port

    cp pkgshare/"configs/envoyproxy_io_proxy.yaml", testpath/"envoy.yaml"
    inreplace "envoy.yaml" do |s|
      s.gsub! "port_value: 9901", "port_value: #{port}"
      s.gsub! "port_value: 10000", "port_value: #{free_port}"
    end
    pid = spawn bin/"envoy", "-c", "envoy.yaml"
    sleep 10
    assert_match "HEALTHY", shell_output("curl -s 127.0.0.1:#{port}/clusters?format=json")
  ensure
    Process.kill("HUP", pid)
  end
end
