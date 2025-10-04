class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v1.9.5.tar.gz"
  sha256 "a31bf063ef5bdabc807d1b205771509b203cf23f81e62e248fd66f0d0266f47c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f300b3756a51aed36f5e7581c81e886c2e5a69a1bbd77fa940602ae0f63e46f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7432eefedef62f52648f45261f01a924884bb5eab34239de1315616a429b1a0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62b7d3a28c01dbb1a253aa891f0c2482326f5a3473351116ba36d99bea12d656"
    sha256 cellar: :any_skip_relocation, sonoma:        "8215adff9cdba72c865b2ef184c1987e9374a31d97efb1eefe47bbdee1edcc99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d798b8b12172373e1201bbaff6f9126c5edabf71d0e585291be796d17a23852"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "494c95899ec95535d026c82aba7af9695b093b295656279b0b7b83f804181742"
  end

  depends_on "python@3.13" => :test
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
    python = "python3.13"
    system "cargo", "init", "--name=brew", "--bin"
    system bin/"maturin", "build", "-o", "dist", "--compatibility", "off"
    system python, "-m", "pip", "install", "brew", "--prefix=./dist", "--no-index", "--find-links=./dist"
    system python, "-c", "import maturin"
  end
end
