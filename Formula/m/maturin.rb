class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v1.8.3.tar.gz"
  sha256 "c67ff594570270c75b6b123a0728aee5ef8871e34a2777ccf99cef10457649c0"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f07b71d793c27a95202b27674fdde84f07f63683d0c5c489b250d3863ab5e72c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22bbf2b7668ec7e27054bbcd147809f67aa93fe16674da8e9988d5b09a055d88"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a7cbda3bb40994236d20ce05872cb4c54af14db99c37a3b59d7706930a23a640"
    sha256 cellar: :any_skip_relocation, sonoma:        "2be3842707e09924541dbd996040da07ff8a5a0ebf631e87033700feb1169ff3"
    sha256 cellar: :any_skip_relocation, ventura:       "b71f626046ca930fba0ac672cda769480f12212ea07d1d0029cb9c7960007818"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7bda662d2cf548520ff1994a228c2e30c7056d1556b60fa1db90bf3ef26504bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43af90ed1f50b58b604c0fbf8d537805b51435a25d2354f8d885fe8b25562347"
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
