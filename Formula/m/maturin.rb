class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v1.12.2.tar.gz"
  sha256 "fe5082a5dcbc36c98d9edace4dd8a6672e83cc1d1d069d8c77a07a618cc67959"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "834f3051079137a328a8298d32e13fea8cdae548729d82ad8568ebafdce27592"
    sha256 cellar: :any,                 arm64_sequoia: "84d455b6d01beaed61708b41f27da27267926f1e462d3a0ad6c2d8489de98ead"
    sha256 cellar: :any,                 arm64_sonoma:  "1ffd1b7446cc718546860a8f1d4936a4c38c4d4454548ce4f4004e44c28e1b43"
    sha256 cellar: :any,                 sonoma:        "9a04d59c522715ec165a3d0dff0f1f24cf2235a53f3a4b7111c9b183990a8479"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75521df205bf0568d0d1b65bbd12236920698897ae2a1e5b1e727e81da933185"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91f9a668c674a85caf1d5077dab7564c7f7b21414c0cc2dd9c08335231277957"
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
