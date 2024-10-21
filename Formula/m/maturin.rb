class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v1.7.4.tar.gz"
  sha256 "19edb033a7d744dd2b4722218d9db47dadb633948577f957b44d8c9b8eececc8"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "565437267821f6f495b7cac9cca4753b43fa1e2eb760bf83d11fb9420ea75cc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4fb18c3ba4bd4f773fcdd8e961b3314a2f3d61adf06497715ea98ac42c5e5ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7ca1c609fea5a30f8094a07ac834bef702994f6fe1f7a740100a0efaab6a6d25"
    sha256 cellar: :any_skip_relocation, sonoma:        "1acf90a18579f828719b504d2ffbab74dfd21606293d2e8f6eb1f3e530ae3f1a"
    sha256 cellar: :any_skip_relocation, ventura:       "05e279fe87e2e07580647f842719b36c90b71e86928d1379c48b3bf6d720c059"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a95136b390e0172132bd495a90ecdb99e7a7638096e6e4f290b8dfda3cea4a3b"
  end

  depends_on "python@3.13" => :test
  depends_on "rust"

  uses_from_macos "bzip2"

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
