class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "27e26b05e9abc474c75402e4e8dd13f045f3dcbe08a8ea48b0eb12c3f96a9cc1"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b4b21ffb6f4109c4401383f0141619d246182b98781d0a8316f32f04b657134a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "622e543b492d7b716c9f6b7fe3e1bdf86058077f44e96a533f4671a42df53f91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a325b30d9998380363689ad5f7f32feba632f80c5c84473665a4f6ad16c3bbcc"
    sha256 cellar: :any_skip_relocation, sonoma:         "a2c3f494c9c7cfc9e3c5d2efdc8006adc917eb9b320e2c89ac547f2c2f2b5f42"
    sha256 cellar: :any_skip_relocation, ventura:        "6c0045d053601c7a22ab7a650c2c2134935ac2808d9fa5c872d851eb17437278"
    sha256 cellar: :any_skip_relocation, monterey:       "779b061c5dba921e7862323ec5c066e929a7c2953c1d01c7309a091f95a08299"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aac38328a9620d44d67e220eb6fa17b5071c148352b880af393c954bec8fa2f7"
  end

  depends_on "python@3.12" => :test
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
  end

  test do
    system "cargo", "init", "--name=brew", "--bin"
    system bin/"maturin", "build", "-o", "dist", "--compatibility", "off"
    system "python3.12", "-m", "pip", "install", "brew", "--prefix=./dist", "--no-index", "--find-links=./dist"
  end
end
