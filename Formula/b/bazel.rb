class Bazel < Formula
  include Language::Python::Virtualenv

  desc "Google's own build tool"
  homepage "https://bazel.build/"
  url "https://github.com/bazelbuild/bazel/releases/download/9.0.0/bazel-9.0.0-dist.zip"
  sha256 "dfa496089624d726a158afcac353725166f81c5708ee1ecc9e662f2891b3544d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36c0beaeb0163c531dd8482873718370b81eaffdfbfc56bdf7bdffa20dac9d78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36c0beaeb0163c531dd8482873718370b81eaffdfbfc56bdf7bdffa20dac9d78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31593800d826f1f9213f01434e92be11f7714d8099ef96c008638f685b622291"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb16b0e131a70def319c839bc3e31ab2f36edd6e87dafaeca878ca8c18dced5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd8fee494df3f626ad57dc1ab952a107f5899911bd1acc52d6a2966df051bd97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87ddf0923c606badd36e8ba0e680ef459292d6e776879e520428b9a1fc124930"
  end

  depends_on "python@3.14" => :build
  depends_on "openjdk@21"
  uses_from_macos "unzip"
  uses_from_macos "zip"

  on_linux do
    depends_on "binutils" => :build # Add this line

    on_arm do
      # Workaround for "/usr/bin/ld.gold: internal error in try_fix_erratum_843419_optimized"
      # Issue ref: https://sourceware.org/bugzilla/show_bug.cgi?id=31182
      depends_on "lld" => :build

      # We use a workaround to prevent modification of the `bazel-real` binary
      # but this means brew cannot rewrite paths for non-default prefix
      pour_bottle? only_if: :default_prefix
    end
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  conflicts_with "bazelisk", because: "Bazelisk replaces the bazel binary"

  resource "absl-py" do
    url "https://files.pythonhosted.org/packages/64/c7/8de93764ad66968d19329a7e0c147a2bb3c7054c554d4a119111b8f9440f/absl_py-2.4.0.tar.gz"
    sha256 "8c6af82722b35cf71e0f4d1d47dcaebfff286e27110a99fc359349b247dfb5d4"
  end

  def bazel_real
    libexec/"bin/bazel-real"
  end

  def install
    java_home_env = Language::Java.java_home_env("21")

    ENV["EMBED_LABEL"] = "#{version}-homebrew"
    # Force Bazel ./compile.sh to put its temporary files in the buildpath
    ENV["BAZEL_WRKDIR"] = buildpath/"work"
    # Force Bazel to use brew OpenJDK
    extra_bazel_args = ["--tool_java_runtime_version=local_jdk"]
    ENV.merge! java_home_env.transform_keys(&:to_s)
    # Bazel clears environment variables which breaks superenv shims
    ENV.remove "PATH", "#{Superenv.shims_path}:"
    ENV.prepend_path "PATH", Formula["binutils"].opt_bin if OS.linux?

    # Workaround to build zlib < 1.3.1 with Apple Clang 1700
    # https://releases.llvm.org/18.1.0/tools/clang/docs/ReleaseNotes.html#clang-frontend-potentially-breaking-changes
    # Issue ref: https://github.com/bazelbuild/bazel/issues/25124
    if DevelopmentTools.clang_build_version >= 1700
      extra_bazel_args += %w[--copt=-fno-define-target-os-macros --host_copt=-fno-define-target-os-macros]
    end

    # Set dynamic linker similar to cc shim so that bottle works on older Linux
    if OS.linux? && build.bottle? && ENV["HOMEBREW_DYNAMIC_LINKER"]
      extra_bazel_args << "--linkopt=-Wl,--dynamic-linker=#{ENV["HOMEBREW_DYNAMIC_LINKER"]}"
    end

    if OS.linux? && Hardware::CPU.arch == :arm64
      extra_bazel_args << "--linkopt=-fuse-ld=lld"
      extra_bazel_args << "--host_linkopt=-fuse-ld=lld"
    end

    if OS.linux?
      extra_bazel_args << "--action_env=PATH=#{ENV["PATH"]}"
      extra_bazel_args << "--host_action_env=PATH=#{ENV["PATH"]}"
    end
    ENV["EXTRA_BAZEL_ARGS"] = extra_bazel_args.join(" ")

    system "./compile.sh"
    bin.install "scripts/packages/bazel.sh" => "bazel"
    ln_s bazel_real, bin/"bazel-#{version}"
    (libexec/"bin").install "output/bazel" => "bazel-real"
    bin.env_script_all_files libexec/"bin", java_home_env

    venv = virtualenv_create(buildpath)
    venv.pip_install resources

    system "#{venv.root}/bin/python3", "scripts/generate_fish_completion.py", "--bazel=#{libexec/"bin"}/bazel-real",
    "--output=bazel-out/bazel.fish"
    system "scripts/generate_bash_completion.sh", "--bazel=#{libexec/"bin"}/bazel-real", "--output=bazel-out/bazel"

    zsh_completion.install "scripts/zsh_completion/_bazel"
    bash_completion.install "bazel-out/bazel"
    fish_completion.install "bazel-out/bazel.fish"

    # Workaround to avoid breaking the zip-appended `bazel-real` binary.
    # Can remove if brew correctly handles these binaries or if upstream
    # provides an alternative in https://github.com/bazelbuild/bazel/issues/11842
    if OS.linux? && build.bottle?
      Utils::Gzip.compress(bazel_real)
      bazel_real.write <<~SHELL
        #!/bin/bash
        echo 'ERROR: Need to run `brew postinstall #{name}`' >&2
        exit 1
      SHELL
      bazel_real.chmod 0755
    end
  end

  def post_install
    if File.exist?("#{bazel_real}.gz")
      rm(bazel_real)
      system "gunzip", "#{bazel_real}.gz"
      bazel_real.chmod 0755
    end
  end

  test do
    # Bazel 9: ensure we're in a workspace. Keep MODULE.bazel minimal (no deps),
    # and provide WORKSPACE for classic mode when bzlmod is disabled.
    (testpath/"MODULE.bazel").write <<~STARLARK
      module(
        name = "homebrew_bazel_test",
        version = "1.0.0",
      )
    STARLARK
    (testpath/"WORKSPACE").write ""

    (testpath/"BUILD.bazel").write <<~STARLARK
      genrule(
        name = "bazel-test",
        outs = ["hello.txt"],
        cmd = "echo 'Hello from the test' > $@",
      )
    STARLARK

    system bin/"bazel", "build", "//:bazel-test", "--repo_contents_cache=", "--noenable_bzlmod"
    assert_equal "Hello from the test\n", (testpath/"bazel-bin/hello.txt").read

    # Verify wrapper script delegation behavior
    (testpath/"tools/bazel").write <<~SHELL
      #!/bin/bash
      echo "stub-wrapper"
      exit 1
    SHELL
    (testpath/"tools/bazel").chmod 0755

    assert_equal "stub-wrapper\n", shell_output("#{bin}/bazel --version", 1)
    assert_equal "bazel #{version}-homebrew\n", shell_output("#{bin}/bazel-#{version} --version")
  end
end
