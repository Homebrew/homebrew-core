class MeshLlm < Formula
  desc "Run large language models across a private mesh of machines"
  homepage "https://github.com/Mesh-LLM/mesh-llm"
  url "https://github.com/Mesh-LLM/mesh-llm/archive/refs/tags/v0.75.1.tar.gz"
  sha256 "cf666e83b6c39bf9da7664614de577441a91c100305469dd6db1c7bae8191387"
  license "Apache-2.0"

  depends_on "cmake" => :build
  depends_on "just" => :build
  depends_on "lld" => :build
  depends_on "ninja" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build
  depends_on "python@3.14" => :build
  depends_on "rust" => :build
  depends_on arch: :arm64
  depends_on :macos

  def install
    # Keep ggml's compiler-cache autodetection from selecting a host sccache
    # that is not on the sandboxed build PATH.
    ENV["LLAMA_STAGE_USE_SCCACHE"] = "0"

    # The packaging scripts invoke `python3` and need Python >= 3.11; make it
    # resolve to Homebrew's python ahead of an older Command Line Tools python3.
    (buildpath/"brew-python").install_symlink formula_opt_bin("python@3.14")/"python3.14" => "python3"
    ENV.prepend_path "PATH", buildpath/"brew-python"

    # Backend-neutral host: the React console assets plus the cargo release build.
    system "just", "release-host-build"
    # Metal native runtime, built from the pinned and patched llama.cpp checkout.
    system "just", "release-runtime-build", "metal"
    # Compose and verify the product bundle: this checks the host's dynamic
    # imports against the release policy and writes the product manifests.
    system "just", "release-bundle", "v#{version}", "dist"

    mkdir "bundle-stage" do
      system "tar", "xzf", buildpath/"dist/mesh-llm-v#{version}-aarch64-apple-darwin.tar.gz"
      cd "mesh-bundle" do
        bin.install "mesh-llm"
        libexec.install "product-manifest.json"
        libexec.install "host-imports.json"
      end
    end

    # The native runtime is a self-contained plugin bundle: its libraries link
    # only against system libraries and resolve each other through @loader_path,
    # so they need no install-name rewriting. Its manifest records a SHA-256 for
    # every file and the loader refuses runtimes whose files have changed, so
    # install the runtime as its packaged archive and unpack it in
    # `post_install_steps`, after keg relocation and re-signing have run.
    runtime_archive = buildpath.glob("dist/native-runtimes/*-metal.tar.gz").fetch(0)
    libexec.install runtime_archive => "native-runtime.tar.gz"
  end

  post_install_steps do
    mkdir_p "{{libexec}}/native-runtimes"
    run "/usr/bin/tar",
        args:           ["xzf", "{{libexec}}/native-runtime.tar.gz", "-C", "{{libexec}}/native-runtimes"],
        writable_paths: ["{{libexec}}/native-runtimes"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mesh-llm --version")
    assert_path_exists libexec/"product-manifest.json"

    # `runtime list` also prints a warning naming any runtime it rejected, so
    # assert on the discovered runtime and on the absence of that warning.
    runtimes = shell_output("#{bin}/mesh-llm runtime list")
    assert_match "meshllm-native-runtime-darwin-aarch64-metal", runtimes
    refute_match "malformed native runtime", runtimes
    refute_match "No local native runtimes found", runtimes
  end
end
