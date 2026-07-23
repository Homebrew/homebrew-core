class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "435f8d5b267e52588fe699cab97a8234e3d98977a9f9e6efe873e04f7f85f92c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e7f3fbdf3e4fbe5e741d2d5193a7b795c7fcf94f088a0660f29765da19d49d7c"
    sha256 cellar: :any, arm64_sequoia: "2ae6a629bc31debb54927902fae05a3265f6b271259b7b5e7cc8e6a7267e504e"
    sha256 cellar: :any, arm64_sonoma:  "931c86d28ce3d635470124b14a89e431a63b83cec19b9e7502a6cd74904f2cb0"
    sha256 cellar: :any, sonoma:        "c48d64cff918c530996b9cfdce8239ac88b63b2a0309d386d58c72d4fb4392b3"
    sha256 cellar: :any, arm64_linux:   "e64c8ea180b4fc4f2b5a06b31a69f511f48407d6f32cb1e6a714600b02f859e7"
    sha256 cellar: :any, x86_64_linux:  "0638356e04b848475ca1e278c152811befd547fd37f8dcd8f784602992c29990"
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
