class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v1.12.6.tar.gz"
  sha256 "d9fb69fb10a4574032feb93da3f98cbfbf4e652340135c968781845aa1f53147"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9360fb507e5aa72dffaabc0d33aad003f7eb95362f6020a595c01c57de963105"
    sha256 cellar: :any,                 arm64_sequoia: "9fb4bca2f3653b666eb253d367753c0b13c240985887c14b44d41a71837d60d1"
    sha256 cellar: :any,                 arm64_sonoma:  "6c65dde090510099ab6c87a698adfa3158afb750a0f80675c8fa9316c124866a"
    sha256 cellar: :any,                 sonoma:        "4bcd43b3bb25296785e57ef41db3670e8b70bccc374a8f48ccb9b21a3c22a931"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e37298867b85609b5068fb7936c5e6a5d35f4b809ba9d536d681e8ce8dd2fbad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0585ba62e439aed2513f92b1436c4ec80ac47b42cbded375023026049b5c8d9"
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
