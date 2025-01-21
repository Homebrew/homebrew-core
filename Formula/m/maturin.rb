class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "8ddaf1655509ae079406635654cbc0c73d622e7c2a537f2465a83e8021dd0cc4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e60829fe8db25243b33e0499ba98c966a6cf75f65b922bdafa5f9fabd0cf17b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03576badd97653639db0063a30fd17134993a3b5d049137b6898ddd9f677791b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e04d41199a16ccb828d2d038a21c001b0ae2e49176e7fa45ee0dce4398809d53"
    sha256 cellar: :any_skip_relocation, sonoma:        "1525a7a60da76a6fc71681a5d460b2d6769bdaaa4958793be5e0455dea30bf49"
    sha256 cellar: :any_skip_relocation, ventura:       "59ce1d0a35f1dc691172784085456cd79e9345f2bc3f0c6810d7d1ee1d0b3909"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acddbbb078231b1c8e358db5c4d598161ad826b385860c4f7e8f4faf99ebd72a"
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
