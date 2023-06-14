class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "57b990348a9182897d64e7bc2b7be6e323912500c10a56174090fa8008173ad0"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75670dbb11b657b02ca4eb3aae14d795eec9025d1351fb56fee6b1db6809a116"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c650f71e1efac6fe6b40f898a3dfd1b89337b567460beffb7662c8e7c71fcd5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f9c6f4d91df7e604d7e1c2e92ae851b3db3a4aa0acd90a2dcea1cc1f06fc0ee"
    sha256 cellar: :any_skip_relocation, ventura:        "946a65187c03c845cd6d27678b5241f6e202ecc928a456deeeb198d087137323"
    sha256 cellar: :any_skip_relocation, monterey:       "e0484a06d454588b4bfec11ad31fdb3e59c40cff68252d38ec0b3b8392b6db06"
    sha256 cellar: :any_skip_relocation, big_sur:        "3697fb5a060e94c1169dc245a937b88d3ede8f483033b4e58908acf7ded5c911"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aeaf6dc363a32173db5523f334ffb8d3b702bb64def1179a5f2bf40bf874710c"
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
