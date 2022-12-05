class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.14.4.tar.gz"
  sha256 "a5c9e64dd98733397d915a10cae241c12428023e679a3c7aa968bded82e5b065"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8ccf5576236cc15f19b3f23bc5c6ba5da0c1c78a20f3ba606c725f2f45ef4cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11e4642682d440ee8f9cee10ed5e3d6bd7728fbd7385067f1a20f86efd22b9bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "67f94788ae17fbc893ac8ac524f14a8b3dbadb5bb2cd887d4415d3371af64e56"
    sha256 cellar: :any_skip_relocation, ventura:        "aea123c577ab9b3bcdb5c97cb820b6cff174a43aa063e5c491c59566a10e3c27"
    sha256 cellar: :any_skip_relocation, monterey:       "d829f0c8646b9ea30914c083d8d6ff872c4a31a05bbf91060f6deeaaf74c2625"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e1f656ca02b6b546b8be13be6455b9da20d2fb063abb16e4693cedb64a2d42f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9aa82ac559d0a658aa2978f6fca5f4c40e040cb3d854e0c0ccc5127188f2e268"
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
