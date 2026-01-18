class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v1.11.5.tar.gz"
  sha256 "4edf379859d0126ed860c1f1905da304ce4aea37f3ad58ede294a3920cb9e3aa"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "38dd24422afdb94e8c9a464adee7e910d52eaa921a20a4cced71c764a54fb119"
    sha256 cellar: :any,                 arm64_sequoia: "976878cb09ce758dff13dced5b25f925248b01a59d381964141cbb235598c81b"
    sha256 cellar: :any,                 arm64_sonoma:  "52b1bc8090dab3e04571706ed24614f942aacea85d3a807af7d5d10fde3e40df"
    sha256 cellar: :any,                 sonoma:        "70406d125626bbaa1d007815264cd0faa236b609c1fb3de4cac2a672b7368cd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7640bdd64b220da0dc990d2f0acde5aed2dd69199cea2bd9b2de92bb174356a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91a44306ed998a45d90dc38e6488faa676eb102d5be92458acaaa2bf22b9ccd1"
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
    system "cargo", "init", "--name=brew", "--bin"
    system bin/"maturin", "build", "-o", "dist", "--compatibility", "off"
    system python3, "-m", "pip", "install", "brew", "--prefix=./dist", "--no-index", "--find-links=./dist"
    system python3, "-c", "import maturin"
  end
end
