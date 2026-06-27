class Pgrx < Formula
  desc "Build Postgres Extensions with Rust"
  homepage "https://github.com/pgcentralfoundation/pgrx"
  url "https://github.com/pgcentralfoundation/pgrx/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "db105c96543559056ae8026ffa7754445883402aeb85fb62325b7072be4e911a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "274e746c89f85efc62bae5dcb88a10379a14d59ca84ab7873619ee238dca241e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e7d3e4fdfac9b289d8fc00e0ccb6f9c39d2e7be24445a2a28095625d19cf982"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "674a6c0268f9f50a43bc7788a17366bb9c052f53cf44de55b658c76fb2a13bd6"
    sha256 cellar: :any_skip_relocation, sonoma:        "71a214033656e0fcc100f47da0061e702c024b5552af505ec6a0ad191a8eff87"
    sha256 cellar: :any,                 arm64_linux:   "75b9117e913a48a3c1c9a2899da2a58254468c8c1e2cd75f0b5c6a7b9ba7dacc"
    sha256 cellar: :any,                 x86_64_linux:  "12078e4b67e737cbd74c98abf828452e6b196cdd5f302e137adbd3b6036bd167"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cargo-pgrx")
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    system "cargo", "pgrx", "new", "my_extension"
    assert_path_exists testpath/"my_extension/my_extension.control"
  end
end
