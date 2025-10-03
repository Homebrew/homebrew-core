class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v1.9.4.tar.gz"
  sha256 "c052ec18498b6dafc727696610a4df49afac54fee29f8020857e301ce2c5f5e0"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b921267ef2ed8fee9840a88276752fa9822a0374e0d117474d6cc812e76cbf66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c929171d7d5026f218930f80d225b772cf202ae6a1635ae5ae1e6fc8a2c53d98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8881c06dacadfbb60a07a769b0fb542da3509116e3ea75c34f9b0218a3af81b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "385d4047c60d3900e5f3a8e40303aae473133ca9ddb548241cf7297e98347037"
    sha256 cellar: :any_skip_relocation, sonoma:        "a53a198274028fe487d1eba5f61cbe3cd8b341a905a5daaa20c823b7fbe351ac"
    sha256 cellar: :any_skip_relocation, ventura:       "b78724ca9f844535b1b781ae331a1220de7a7f8ad6feb8012ced035a4549bd31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc77badce02bf471809b30f5451082848eb9b5ebb7a7751271a085de1f5ca977"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74a2503871bc9ac882eec1f05faaf9838d1ceaeb9a28169b9f56600c017be412"
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
