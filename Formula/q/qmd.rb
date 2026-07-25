class Qmd < Formula
  desc "On-device hybrid search engine for Markdown files"
  homepage "https://github.com/tobi/qmd"
  url "https://registry.npmjs.org/@tobilu/qmd/-/qmd-2.5.3.tgz"
  sha256 "5c6084e9bdf041c47a55402e3b17bf8dd6d0262c39556261cd723d5f3d280c4e"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "ggml"
  depends_on "node"

  uses_from_macos "sqlite"

  resource "sqlite-vec" do
    url "https://github.com/asg017/sqlite-vec/releases/download/v0.1.9/sqlite-vec-0.1.9-amalgamation.tar.gz"
    sha256 "3acd67cb4aff080c7050926fd3cf8227905fe5b7ee3829d8ee5024ab1283cf61"
  end

  # node-llama-cpp uses private llama.cpp APIs and requires its matching release.
  resource "llama.cpp" do
    url "https://github.com/ggml-org/llama.cpp.git",
        tag:      "b10068",
        revision: "571d0d540df04f25298d0e159e520d9fc62ed121"
  end

  def install
    # Build native npm dependencies while preventing node-llama-cpp's
    # postinstall from selecting a bundled binary.
    ENV["NODE_LLAMA_CPP_SKIP_DOWNLOAD"] = "1"
    inreplace "package.json", '"node-llama-cpp": "3.18.1"', '"node-llama-cpp": "3.19.1"'
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    ENV.delete("NODE_LLAMA_CPP_SKIP_DOWNLOAD")

    node_modules = libexec/"lib/node_modules/@tobilu/qmd/node_modules"

    extension = OS.mac? ? "dylib" : "so"
    platform = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    sqlite_vec = node_modules/"sqlite-vec-#{platform}-#{arch}"
    resource("sqlite-vec").stage do
      args = %w[-fPIC -shared -O3]
      if OS.mac?
        args += %W[
          -Wl,-install_name,@rpath/vec0.#{extension}
          -Wl,-headerpad_max_install_names
          -Wl,-undefined,dynamic_lookup
        ]
      else
        args << "-lm"
      end
      system ENV.cc, *args, "sqlite-vec.c", "-o", "vec0.#{extension}"
      rm sqlite_vec/"vec0.#{extension}"
      sqlite_vec.install "vec0.#{extension}"
    end

    llama = node_modules/"node-llama-cpp"
    resource("llama.cpp").stage(llama/"llama/llama.cpp")
    gpu = OS.mac? ? "metal" : "false"
    ENV["NODE_LLAMA_CPP_CMAKE_OPTION_GGML_NATIVE"] = "OFF"
    ENV["NODE_LLAMA_CPP_CMAKE_OPTION_LLAMA_USE_SYSTEM_GGML"] = "ON"
    ENV["NODE_LLAMA_CPP_CMAKE_OPTION_ggml_DIR"] = formula_opt_lib("ggml")/"cmake/ggml"
    system node_modules/".bin/node-llama-cpp", "source", "build", "--gpu", gpu, "--noUsageExample"

    # Remove bundled native binaries and files only needed to build llama.cpp.
    rm_r node_modules/"@node-llama-cpp"
    rm_r node_modules/"@reflink" # optional optimization; ipull falls back to copying
    rm_r node_modules.glob("tree-sitter-*/prebuilds")
    rm_r [llama/"llama/llama.cpp", llama/"llama/xpack"]
    rm llama/"llama/gitRelease.bundle"
    llama.glob("llama/localBuilds/*").each do |build|
      rm_r build.children - [build/"Release", build/"buildDone.status"]
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    ENV["HOME"] = testpath
    notes = testpath/"notes"
    notes.mkpath
    (notes/"brew.md").write <<~MARKDOWN
      # Homebrew Formula

      Fermentation converts sugars into carbon dioxide and alcohol.
    MARKDOWN
    (notes/"other.md").write <<~MARKDOWN
      # Other Notes

      This document discusses software packaging.
    MARKDOWN

    system bin/"qmd", "collection", "add", notes, "--name", "test-notes"
    output = shell_output("#{bin}/qmd search fermentation --format json")
    assert_match "qmd://test-notes/brew.md", output
    assert_match "Fermentation converts sugars", output
  end
end
