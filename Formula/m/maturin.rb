class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "623111bddb2d7f6f4ba2e64038f91f8b673bd6f95dd6fcbaf334b7af7789b48d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9aa56f19ab4091c46c9273e8109711fb83ff1e769f6b263a5381a2dd16bd2edb"
    sha256 cellar: :any, arm64_sequoia: "a9488e045ca3d582951d19dd2deb6b4faa70cb6ece73c2b7edc155c2209988dd"
    sha256 cellar: :any, arm64_sonoma:  "1a3448e5b1f40a07e387ed7d9188c1ad02bf71ab0bb096e4b5b801bb57e89721"
    sha256 cellar: :any, sonoma:        "efd85533263473b7a4aacd5b1c79cfcfd55f5e4815be2aa1c8cd54795c1fcfb8"
    sha256 cellar: :any, arm64_linux:   "e50c5f3cce47a28b1167be83eff27c02cf8a153eced7528b205867c20d865d5f"
    sha256 cellar: :any, x86_64_linux:  "e9ae58b15640e93626929b6466cf04821aad37ea1eb83a603fc55c7d099a0bf8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => [:build, :test]
  depends_on "python@3.14" => :test
  depends_on "xz"

  def install
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    if DevelopmentTools.clang_build_version >= 1500
      ENV.remove "HOMEBREW_LIBRARY_PATHS",
                 recursive_dependencies.find { |d| d.name.match?(/^llvm(@\d+)?$/) }
                                       .to_formula
                                       .opt_lib
    end

    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"maturin", "completions")

    python_versions = Formula.names.filter_map do |name|
      Version.new(name.delete_prefix("python@")) if name.start_with?("python@")
    end.sort

    newest_python = python_versions.pop
    newest_python_site_packages = lib/"python#{newest_python}/site-packages"
    newest_python_site_packages.install "maturin"

    python_versions.each do |pyver|
      (lib/"python#{pyver}/site-packages/maturin").install_symlink (newest_python_site_packages/"maturin").children
    end
  end

  test do
    python3 = "python3.14"
    system "cargo", "init", "homebrew", "--name=brew", "--bin"
    cd "homebrew" do
      system bin/"maturin", "build", "-o", "dist", "--compatibility", "off"
      system python3, "-m", "pip", "install", "brew", "--prefix=./dist", "--no-index", "--find-links=./dist"
      system python3, "-c", "import maturin"
    end
  end
end
