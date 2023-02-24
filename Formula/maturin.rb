class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.14.14.tar.gz"
  sha256 "de895e09e1cf609a0f31260b13b240d5a3530616e0ab05b7db01e7812372c2e0"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62d36b38fc88a77f0eaf56ef8951e3d941ea5d5a4bcaf253508ff3ef7204d900"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76ee0f998729a2f743fb85b8596d8a10a416ded561520ff2e18615dde36c448b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d3259a21cbd5fdb3d38cec5282dcedb39da318dac9355758977b643949f5c0c"
    sha256 cellar: :any_skip_relocation, ventura:        "e5134cd396e608d83db4b4324a7f51c81302b3880dd1d84b57151681d2a5ab75"
    sha256 cellar: :any_skip_relocation, monterey:       "e61d09f9145da8a3dd57646254dfe276bffbf2a6e86ebaca1fbf43ecd5a99b76"
    sha256 cellar: :any_skip_relocation, big_sur:        "b865577364cb942f59a7784e41e6691b5b3f0af9f5824fa336443994d685c457"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8999f74b24a1c4c161dda9748f35bfd3989c92bbc9ce4d6000cc34e86b1d36a6"
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
