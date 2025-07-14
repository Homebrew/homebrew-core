class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "ad374fbf04340083add2a47f3b3acdd809ceea1275d80cb5918cde80940a2fca"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d14c94a93020669faceba1a85269e3475f016780816b5647b2320ace4bb99c68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb6f78ccca323a041316da5986633ac393e1a83380bbb5ccdde1713f2b18d9f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dfbe1127cd5b73fb55becdc948e6bc9b2a2e05511257d3c8364391cbeaa0fc7c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0cd3ba93743cc1954bf3287f499fed8a9d21589843c8f955fe8ff3449de1a36a"
    sha256 cellar: :any_skip_relocation, ventura:       "a079eefffe41c3329197c37cbf525404e66e93ffa26e204b8c09f43afb8bfb93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be59c21ec4a3914c6580452392bd918b1f00f1c2e41e32e900aa02724f29ec3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69bc3ea9e128fa250a298d164241c157484ca93aeece5af247441335067140cc"
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
