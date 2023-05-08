class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "15ab24cc43da24ceca5175847a43ac59b31447b8b545cecca902d219110faee9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80068de7a13dd41e3c0d75f565685b93fae8f0993de77969b0b554d7e6f79065"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea5ecb0810853940177acb03847f72b6287eee8249183100c06bdc40bf3534d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a40502226ba93ac123a71d5af34991c4560dd87ffb0c8e33202011df3048d12f"
    sha256 cellar: :any_skip_relocation, ventura:        "05b594f23e0b31b561cb558228fee83dc40bbfccff96db69ba8875b0c11093ba"
    sha256 cellar: :any_skip_relocation, monterey:       "98c621664bcbb8264afb25a09353ab6507c0e5dd4a79c36544e3f4700064c215"
    sha256 cellar: :any_skip_relocation, big_sur:        "c782956b84287b10734a86c82999adfc1b4496333fd866b44735d568c6fca5df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32abd23b0fae7c14061bf560d85f91972c8b06383d53d54960ad267cd100cfc1"
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
