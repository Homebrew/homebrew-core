class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v1.10.2.tar.gz"
  sha256 "8acb4eb224896b3fa67036680e9e7908eeb8e5c2ea3a495e987a3f2edb666f36"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a86f93d1e7e760798d607ccfbc4469d7fbe5bd0f6432e583066da6f7db833e9c"
    sha256 cellar: :any,                 arm64_sequoia: "b5aa3a12ce060aeedaf598e18549850f690ae8cb9e701f5a9dd71d881543edde"
    sha256 cellar: :any,                 arm64_sonoma:  "36ba4894ead30f6a85e85f41266587f06c18683e017fea848a2a3567e85b6f6b"
    sha256 cellar: :any,                 sonoma:        "e470aea2b5f0ba344518fe653d9ce60d905988ce4714cabeb4376f8873baa5ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09b9c7c1e83ff024a73686c87220ea8f532f684bf3dac7caa3668c92d5209ec7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc2dffdd954054c5ebc1ae0788b8ec610c205d1f2585a5d5d3ed7f8953096329"
  end

  depends_on "python@3.14" => :test
  depends_on "rust"

  uses_from_macos "bzip2"
  uses_from_macos "xz"

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
    system "cargo", "init", "--name=brew", "--bin"
    system bin/"maturin", "build", "-o", "dist", "--compatibility", "off"
    system python3, "-m", "pip", "install", "brew", "--prefix=./dist", "--no-index", "--find-links=./dist"
    system python3, "-c", "import maturin"
  end
end
