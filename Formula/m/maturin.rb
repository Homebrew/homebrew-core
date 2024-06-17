class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "10809d4df85532cb70d9f186117cac8b2d2fa9b03c8f2fb53a8dc8a531f5afeb"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "03aa70283ce54686043691afe12e2db8b4b67467000f81e9fd14be1d6c8838dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2b9a3422d09d64f029485ddedc4119b683c1981c61d70b784531d42a71d22d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d42604f20c9cdea68cb9d8ae1d240fbb0558df35ce9a6df5272b2c38ddfdc1f4"
    sha256 cellar: :any_skip_relocation, sonoma:         "7bc8cdb084d39d57e5f3653572d208efa152c7fd5f5f17e9f9503565d7c7e604"
    sha256 cellar: :any_skip_relocation, ventura:        "d28a84793ace2256e1b0a0e12a24216824646544cf82070f71d1accb68aef1e2"
    sha256 cellar: :any_skip_relocation, monterey:       "04e6b3fbc65189ee76fee372cd193635d0dbd96864581e0d1ecebab9c60f9b3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "716e67803b377ce3c121b2ad38eb854b4823029c9f836a2e60a28296693a671a"
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
