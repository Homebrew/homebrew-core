class Envoy < Formula
  desc "Cloud-native high-performance edge/middle/service proxy"
  homepage "https://www.envoyproxy.io/index.html"
  url "https://github.com/envoyproxy/envoy/archive/refs/tags/v1.38.3.tar.gz"
  sha256 "db23fed5e174e7988e4b0eaf7718cd3c33230f334bb3fa458e90549a506a8944"
  license "Apache-2.0"
  head "https://github.com/envoyproxy/envoy.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bfdad5c44fea51b93d8ab520f18226b6f3bf6b2be2d3dbf59df22dca366d780c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c43a1245cb59878ec057591d691f6682728f6ca135c137951d72e9ad53ef6570"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e83ee9a089c843e842503ba92e54dde6bd5ee519a4c6a85cc1e7f0d3ace2c3d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "16f3f2435388be09f6c575d8dfde23661144a8b3492a9976538d23e87f49f8d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fe6feca60549fe7540232f8fbb9dcebf51271d36d47a76315431349118c9f6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea511854fe3d1f6b6f7b77a2d8c828f5c92af0436903dbb7da56aebc15553e66"
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
    formula_opt_bin("bazelisk")/"bazelisk"
  end

  def llvm_formula
    Formula["llvm@18"]
  end

  def install
    ENV.remove "PATH", "#{Superenv.shims_path}:"

    # rules_foreign_cc CMake try-compile can pick GNU ld from PATH and fail to link
    # against Envoy's configured sysroot/toolchain. Keep clang/llvm tools but drop binutils.
    ENV.remove "PATH", ":#{formula_opt_bin("binutils")}" if OS.linux?
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
    ln_sf formula_opt_bin("libtool")/"glibtool", llvm_path/"bin/glibtool"
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
    yq_bin = formula_opt_bin("yq")/"yq"
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
