class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "19eacc3befa15ff6302ef08951ed1a0516f5edea5ef1fae7f98fd8bd669610ff"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ac6f489ca22aa4f6cb411b7ee0fc36d6fbaa6e6b940e0cce811a512d8d29557c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d84c0788904a7553bed9991e24beaa51565dce98b0e2883fbf3ab5c63a829e8d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebbee243e035f679192422efffc84688b95f2b30793882debe999d6b990a945d"
    sha256 cellar: :any_skip_relocation, sonoma:         "03e2117430b88ad8219937bed7d08340c6745889dad57933ec9e8a6d0dabb8ba"
    sha256 cellar: :any_skip_relocation, ventura:        "799978386674d99008a88d45cfa659747b01cd4efe38497d78b0bcf995dd0839"
    sha256 cellar: :any_skip_relocation, monterey:       "e4a31781cced921fc214d6610778efcf2e31566c2a7569e246fa66370df44ade"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c6f2f3baa0da92565d5af8102220ec9a711759407ab8435198f2c1b52acf371"
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
