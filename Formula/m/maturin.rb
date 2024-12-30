class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "481c6b354ef06d5eb5c52a7ab8bc01463927a291dabea2bf3257d56edd827f16"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4521bb2dbeaff9c7c8682297cc9b51dda5453dc482896bfd70c299fee3aa2a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c41f4a8997c896bafb73ffacd80bd18ba7fdb04dde86e1b3f91016f11f4ede7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae081244e9c75bdd6739ab52a11b72fde931814b498c2c5fda21e407da0bb95e"
    sha256 cellar: :any_skip_relocation, sonoma:        "706c448382900788314774f13d632d3b04c716e0a827f2fd794a0459ad9e02dc"
    sha256 cellar: :any_skip_relocation, ventura:       "77d8a81d377dcb3bb5f9c2079170671139f68ab212a759f707c82e9ec57df81d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdeec08dad9132ee7d99d9a87353fba37f965eeecc93cde6b26586b59811f983"
  end

  depends_on "python@3.13" => :test
  depends_on "rust"

  uses_from_macos "bzip2"

  # patch to not panic with "`project.version` field is required", upstream pr ref, https://github.com/PyO3/maturin/pull/2417
  patch do
    url "https://github.com/PyO3/maturin/commit/f3d2e00638cfa017a39f67dcf641a85740540119.patch?full_index=1"
    sha256 "c2599129a51b9d560f197d213bc295a948e5f29fdb569011a5d3dee5c990df5b"
  end

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
      (lib/"python#{pyver}/site-packages").install_symlink newest_python_site_packages/"maturin"
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
