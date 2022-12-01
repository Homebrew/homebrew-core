class Maturin < Formula
  desc "Build and publish Rust crates as Python packages"
  homepage "https://github.com/PyO3/maturin"
  url "https://github.com/PyO3/maturin/archive/refs/tags/v0.14.3.tar.gz"
  sha256 "33d1bfe3909d06a406775410a712a41282ecaaf248d038d4ada8446044032896"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/PyO3/maturin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a005ffc84582ece74e8661b2401e4bf6f9a1379d3f20119ef915c25cacf2b504"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0501c949855b618298e41512655a7a0f52feebe48bb9afa1ae6891c024fb3b32"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ea51b85f58e82bcb3d1c7540a0a46751aaaeac306ee46576513d83b41b054c6"
    sha256 cellar: :any_skip_relocation, ventura:        "a11ac0864c10ef4466b480a0cc4a873d2fc344204c57e4483c95457a1ac6f831"
    sha256 cellar: :any_skip_relocation, monterey:       "7e347c9cb564a38aafee8aadfc3ec2ff307fbb82cadd863d98792cbb23f67de9"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd08a9921b9f44f16d892f04c394f0a5ef47cb6d08ea967889c1eeb0f7804a50"
    sha256 cellar: :any_skip_relocation, catalina:       "73812a9de2457178d4388cbfea786c95bff34edd068e42b00695b50b21cd126f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3953e0af9a23a4039648cbc629366f86422636d9ae41aabcc249e18ed581f570"
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
