class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "18198cc9421d04933586b9730abcdd80fe3484e209d2b8223aa7dc1f12c4c3fe"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "816bac13e0ade88644be6302046a122933eb764144319b0e285d71886d4f7ced"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f0070fd7512a2d053c2570ea2950bdbc6e93e82c32a6d0b6e2a87073245d174"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc1f48134f94033c3076ec81789f8535cdd7bfbe491a0c4ab7fabd77da81ce15"
    sha256 cellar: :any_skip_relocation, sonoma:         "2624f61bf61c382b484327da793647605b1f148febfa2986903f48a2647d6c0d"
    sha256 cellar: :any_skip_relocation, ventura:        "dcce958776df8b4918d45cef232bb4397b9dbbaf2b5595a08d2bd0d51c497a49"
    sha256 cellar: :any_skip_relocation, monterey:       "b449b675cb65e15b297278034cb6638c49788c18ae71a528de6d3cb1846a52a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b6989129f8ef6742a60e6284ce41236e7a302b571eaa0b0561345e92c777ffc"
  end

  depends_on "python@3.12" => :test
  depends_on "rust"

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
