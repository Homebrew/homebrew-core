class Envoy < Formula
  desc "Cloud-native high-performance edge/middle/service proxy"
  homepage "https://www.envoyproxy.io/index.html"
  url "https://github.com/envoyproxy/envoy/archive/refs/tags/v1.40.2.tar.gz"
  sha256 "5238e7c8accea26de78c89169945fd47478555852e4e1ae043ab7d13575ffa81"
  license "Apache-2.0"
  head "https://github.com/envoyproxy/envoy.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "33d87c6eba3678acc6a1613b269ec26392f7cd29f8c4d3b7a4874585d590dcb9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "01ca9c90e60f371aa11b4ce1c401e341f736513a0327d8614cb23a3bbe7964da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "922d1f2d480f77a69d82560c30fb29bb4a665b9470751d66a0a4bf48b6bfcd69"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "52573390ef43b0bee73638b51b3f66beddaf371e39d4ba42b01c45ad1042462c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "fe89cec8a2c2234f3601dd541854384edc1bfa38985acad78784c1ae77f0073d"
  end

  depends_on "bazel@8" => :build
  depends_on "cmake" => :build
  depends_on "go" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  uses_from_macos "python" => :build

  on_macos do
    depends_on xcode: :build
  end

  def install
    # Drop hickory DNS: its rust SDK pulls in mockall (incompatible with macOS)
    inreplace "source/extensions/extensions_build_config.bzl",
              /^\s*"envoy\.network\.dns_resolver\.hickory":.*\n/, ""

    # Build with brew Bazel rather than Bazelisk downloading it
    rm ".bazelversion"

    # Build with brew CMake, Go and Ninja rather than Bazel downloading them
    # https://github.com/envoyproxy/envoy/blob/main/bazel/README.md#building-with-host-provided-toolchains
    inreplace "MODULE.bazel" do |s|
      s.gsub!(/mode = "binary",\n\s*version = .*\n/, "mode = \"system\",\n")
      s.gsub!(/^go_sdk\.download\(.*?^\)\n/m, "go_sdk.host(name = \"go_sdk\")\n")
    end
    # Reuse `googleapis` rather than grpc-httpjson-transcoding's own copy, which duplicates symbols on macOS
    (buildpath/"MODULE.bazel").append_lines <<~STARLARK
      transcoding_deps = use_extension("@grpc-httpjson-transcoding//:extensions.bzl", "non_module_deps")
      override_repo(transcoding_deps, com_google_googleapis = "googleapis")
    STARLARK

    if OS.linux?
      # Use GCC with a dynamically linked libstdc++ rather than statically linking a C++ standard library,
      # and drop the remote-execution platform that `--config=gcc` selects
      inreplace ".bazelrc" do |s|
        s.gsub! "-l%:libstdc++.a", "-lstdc++"
        s.gsub!(/^build:gcc --host_platform=.*\n/, "")
      end
    end

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
      --jobs=#{ENV.make_jobs}
      --@proxy-wasm-cpp-host//bazel:engine=wamr
    ]
    if OS.mac?
      # Set the bottle deployment target for Apple toolchain actions and CMake subprocesses.
      args += %W[
        --action_env=MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}
        --host_action_env=MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}
        --macos_minimum_os=#{MacOS.version}
        --host_macos_minimum_os=#{MacOS.version}
      ]
      # wamr's assembly is only preprocessed for its Darwin symbol names with `-x assembler-with-cpp`
      args << "--per_file_copt=external/wamr\\+/.*\\.s@-x,assembler-with-cpp,-DBH_PLATFORM_DARWIN"
    end
    if OS.linux?
      # Prefer the local GCC toolchain over the registered LLVM and remote ones, and raise its C++17 default to C++20
      args += %w[
        --config=gcc
        --extra_toolchains=@local_config_cc_toolchains//:all
        --cxxopt=-std=c++20
        --host_cxxopt=-std=c++20
      ]
    end

    # `--config=macos` resets the action PATH to `/opt/homebrew/bin`, which hides keg-only deps
    args << "--repo_env=PATH=#{env_path}"

    # Write the commit in SOURCE_VERSION. See tools/github/write_current_source_version.py
    (buildpath/"SOURCE_VERSION").write Utils::Git.get_tar_commit_id(cached_download) if build.stable?

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
