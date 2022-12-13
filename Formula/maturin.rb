class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.14.6.tar.gz"
  sha256 "28ac0c34b55f938ba03aa123fec6b01ebec925e12ee37dd6967fa20d986d082c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbd458b7afed6e6d549f808d6c329106ab15a7ffc4b4069faaa86b908518438d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "042a4d2d8003264b099a5f0be849e0d355196ecaec661d85426c5fb6d3a10cbd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9575d38b489086a41f9ba3d7e5f7359bc7919ab70d6558d93519edfb02718181"
    sha256 cellar: :any_skip_relocation, ventura:        "3c47afb039729d7d051e25c58c206587a6463c2723dd748ff814e6cef77615f8"
    sha256 cellar: :any_skip_relocation, monterey:       "ffe2e6fa83f1251424aaf19a0771f94006d6df85f7964501b1ffb9a2c0d13179"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ea99ff2d097c3a77f7bfcdc0bc6011fd1d7b4171c23d378f6cee8ba2576304c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35ab6a0844baa83a94b4ae8631356fdeacfd067bffb1f6e938c326304285dd76"
  end

  depends_on "python@3.11" => :test
  depends_on "rust"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"maturin", "completions")
  end

  test do
    python = Formula["python@3.11"].opt_bin/"python3.11"
    system "cargo", "new", "hello_world", "--bin"
    system bin/"maturin", "build", "-m", "hello_world/Cargo.toml", "-b", "bin", "-o", "dist", "--compatibility", "off"
    system python, "-m", "pip", "install", "hello_world", "--no-index", "--find-links", testpath/"dist"
    system python, "-m", "pip", "uninstall", "-y", "hello_world"
  end
end
