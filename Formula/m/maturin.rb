class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "2bfb3ec1ef1c15163ac006b09f895d17bd7ce0229416be952cd49065842acfc0"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "63997fbb00b7d12457b08260ffca631abba2f7d419147621ff4cbdcb59f16ebd"
    sha256 cellar: :any,                 arm64_sequoia: "528521f9c3fe772e2d92dfee57e7c5f1f62e9f13e922d9262d4b49e88d33fd2c"
    sha256 cellar: :any,                 arm64_sonoma:  "756b61b1a993c1580d1f9f54d3cf4eaef9e56ac8d2bf118c105260c180b5dfcb"
    sha256 cellar: :any,                 sonoma:        "a5d6976cf8883901f3d5bdb2a0d0e40ee8660278aa98b5717113f55386a1e21e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95a84c1ee73310e5bc155afeb47b99a78e85dc7c98b82732663bccbcfd6746b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e8c66239fecafd5fdf52697489f549858fe02be35bf1ce1d7f861f1b00c499c"
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
