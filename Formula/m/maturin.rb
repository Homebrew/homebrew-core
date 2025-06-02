class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v1.8.6.tar.gz"
  sha256 "ab092813266355e08b2feeb0b138c8a47be7cac44a0ed45c9e04722ae94b8bf5"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4604fc872a8d902a59f8f8f00aed7ebc6e84697abc8aba7eb841db1614697fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffd64bda1299b9fbbf6ff9739f102652ae0d447ba3e65d0b7695dc92e8cb8c66"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18a29b6b4ee5e90e9479c4388c2235073d2336d0f333b97a91d13de51330deb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "983104a3c26f06773586c01d329dbeb90920707d55210d8683fd3a1cfee16513"
    sha256 cellar: :any_skip_relocation, ventura:       "0791bd493ee99234a59419e8352275c992131e38be0239d659fe0aa76b15cab1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88a16df0161807aa5c4feda7bfeb2a66a3e2f5406d353d995dd83dd6eaef3a44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "123b144d3952ff54df35a13843738028fc5e8b72d3165b9ebf28e59a52b83bb1"
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
