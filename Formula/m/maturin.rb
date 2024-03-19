class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "19eacc3befa15ff6302ef08951ed1a0516f5edea5ef1fae7f98fd8bd669610ff"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8fc79f12a929026da868cbb73643bf0aae2ab4a4a6af069b6fe67541c0417a35"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef0781946e83686e56b45b5070b84b4ecd15c330ec605004115bb01cae7d2de9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfb5abc92c699651e3c4f2c1486d68a49e38e71a94264ab7b2594d9a8b6b634e"
    sha256 cellar: :any_skip_relocation, sonoma:         "048e3a2794746a71ec0e084fcf75f3ad9592dce289253158df806e2d73aa3d13"
    sha256 cellar: :any_skip_relocation, ventura:        "3178dfec202bda2d86d599c01cae985e3a1003cb73081d0106636f48086d3e77"
    sha256 cellar: :any_skip_relocation, monterey:       "fb1502a2ebf260ed013f57750f39f3c2428c28c306cdd9de2d59e1c3f15d33bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "022e831c7874c173b2030d3f86c4cf727ca91a80e1ca5261dc65d02147b086c3"
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
