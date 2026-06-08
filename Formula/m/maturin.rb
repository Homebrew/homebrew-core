class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v1.13.3.tar.gz"
  sha256 "17d062a73781cf4cd4eb8b0188e8cf037eece711feef0386a22f0975e4e4f34e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "94676480e670973096e41aafd0e810a2211ebd2ca0bea0c5182f2a79f8aca4bf"
    sha256 cellar: :any,                 arm64_sequoia: "a7e86c0fd67ecdd541a1b2b2c4b20a21e14052e0fb43fe5205d3e70eafa66c45"
    sha256 cellar: :any,                 arm64_sonoma:  "fe91a9e5c9ee729952ce70eff25544356ef7174f45cf1d3c33cd68c3e91b3bd2"
    sha256 cellar: :any,                 sonoma:        "f056e1c0f3b6cdcddd6f031f39d0b56c515d28eb2b4570653be40df1d15d4295"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fbce31228ded294a176defb2913e29885bb268a69f95c2c0460c2362d68b932"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "000da0f9ceb16d8bcf4aaf5b8b548a13120968e7ef0779c4ecf2354cd99a16c0"
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
