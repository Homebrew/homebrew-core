class Envoy < Formula
  desc "Cloud-native high-performance edge/middle/service proxy"
  homepage "https://www.envoyproxy.io/index.html"
  license "Apache-2.0"

  stable do
    url "https://github.com/envoyproxy/envoy/archive/refs/tags/v1.39.1.tar.gz"
    sha256 "3fca3330b3c9b632d0039f4da1ece3e177fc12348907ebaa8be7b489a9f9287f"

    depends_on "llvm@18" => :build

    # Allow using host-installed toolchains
    patch do
      url "https://github.com/envoyproxy/envoy/commit/be513213e888c443f4e00b1343cc05149f4f92a7.patch?full_index=1"
      sha256 "363bf44a752c44b3532b7ce6ebc541e8a85b528ae7c79a6f7e621c881358a106"
      type :backport
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a5a6c1b9ab0abb5fe0b5587ae4dd070995480fa4f3ab103b33774d9c1a0a5093"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0de95c4e5eef41062b71a971fb73ab1ef4f37801db1823b7e3789a021db812bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "849820437bb33216fa7b3ca3063262b0fdb74d36648ac7d34dcfb6d72352f015"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "fd7562f7e481dd769020ca9fdac55301f1bf66c489aefdbd5559fef8fc2cd96d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4bc227af9374a1d9d7d2539f9c69c9cd7fc36b94abffca389b62629470cf9034"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a9473b7a8c6ee091feb9dc7453d7b1b788db239ec7fdfd3542862053a16bf96e"
  end

  head do
    url "https://github.com/envoyproxy/envoy.git", branch: "main"

    depends_on "lld@22" => :build
    depends_on "llvm@22" => :build
  end

  depends_on "bazel@8" => :build
  depends_on "cmake" => :build
  # TODO: unpin go@1.26 when envoy updates to rules_go >= 0.62.0
  # ref: https://github.com/bazel-contrib/rules_go/pull/4641
  depends_on "go@1.26" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  uses_from_macos "python" => :build

  on_macos do
    depends_on xcode: :build
  end

  def install
    # Drop hickory DNS: its rust SDK pulls in mockall (incompatible with macOS)
    # and references `@llvm_toolchain_llvm` labels that aren't registered when
    # LLVM is injected via `BAZEL_LLVM_PATH`.
    inreplace "source/extensions/extensions_build_config.bzl",
              /^\s*"envoy\.network\.dns_resolver\.hickory":.*\n/, ""

    # Build with brew Bazel rather than Bazelisk downloading it
    rm ".bazelversion"

    # Build with brew CMake, Go, Ninja and Python rather than Bazel downloading them
    # https://github.com/envoyproxy/envoy/blob/main/bazel/README.md#building-with-host-provided-toolchains
    # TODO: look into support via bzlmod
    if build.stable?
      inreplace "WORKSPACE" do |s|
        s.gsub! "envoy_dependency_imports()", "envoy_dependency_imports(use_host_tools = True)"
        s.gsub! "envoy_dependencies_extra()", "envoy_dependencies_extra(use_host_tools = True)"
      end
    end

    # Stage a local toolchain root to match official LLVM layout needed by upstream
    ENV["BAZEL_LLVM_PATH"] = llvm_path = buildpath/"llvm-toolchain"
    ENV["BAZEL_USE_HOST_SYSROOT"] = "True"
    llvm = deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+(\.\d+)*)?$/) }
    llvm_path.install_symlink(llvm.opt_prefix.children.select(&:directory?) - [llvm.opt_bin])
    (llvm_path/"bin").install_symlink llvm.opt_bin.children
    (llvm_path/"bin").install_symlink formula_opt_bin(llvm.name.sub(/^llvm/, "lld")).children if build.head?
    (llvm_path/"bin").install_symlink which("libtool") if OS.mac? # rules_foreign_cc expects Apple libtool for AR

    # Bazel cannot run in superenv. Also drop binutils as rules_foreign_cc CMake try-compile
    # can pick GNU ld from PATH and fail to link against Envoy's configured sysroot/toolchain
    env_path = (ENV["PATH"].split(":") - [Superenv.shims_path.to_s, formula_opt_bin("binutils").to_s]).join(":")

    bazel_args = %W[--output_user_root=#{buildpath}/user_root]
    args = %W[
      --compilation_mode=opt
      --curses=no
      --noincompatible_strict_action_env
      --verbose_failures
      --action_env=CMAKE_POLICY_VERSION_MINIMUM=3.5
      --action_env=PATH=#{env_path}
      --host_action_env=PATH=#{env_path}
      --repository_cache=#{HOMEBREW_CACHE}/envoy-repository-cache
      --jobs=#{ENV.make_jobs}
    ]
    if build.stable?
      args += %w[
        --noenable_bzlmod
        --@envoy//bazel/foreign_cc:parallel_builds
        --define=wasm=wamr
        --copt=-Wno-nullability-completeness
      ]
    end
    if OS.linux?
      # lld needs help finding libc++.a and libc++abi.a in a non-standard path
      args += %W[
        --linkopt=-L#{llvm_path}/lib
        --host_linkopt=-L#{llvm_path}/lib
        --config=clang-local
        --repo_env=BAZEL_DO_NOT_DETECT_CPP_TOOLCHAIN=1
      ]
    end

    # TODO: remove when unpinning go@1.26
    # `--config=macos` resets the action PATH to `/opt/homebrew/bin`, which hides keg-only deps
    args << "--repo_env=PATH=#{env_path}"

    # Write the current version SOURCE_VERSION.
    system "python3", "tools/github/write_current_source_version.py", "--skip_error_in_git",
           "--github_api_token_env_name=HOMEBREW_GITHUB_API_TOKEN"

    system "bazel", *bazel_args, "build", *args, "//source/exe:envoy-static.stripped"
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
