class Oxipng < Formula
  desc "Multithreaded PNG optimizer written in Rust"
  homepage "https://github.com/shssoichiro/oxipng"
  url "https://github.com/shssoichiro/oxipng/archive/refs/tags/v9.1.4.tar.gz"
  sha256 "90c5e32c556c49e8fb2170f281586e87f7619fd574b4ccf1bc76e2f6819bba77"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "668b8d167ddc952d0ad8b146695abf06cd5cfc75c3708d40091a6289351f43ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8710b20b4af22087fa5f06f190e155d0969e6fef2b3815f35b307c68756395b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d06dcc039c3bf834b3113edaf709b8078be595da4aaacc67506e8233db7279e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6d39e08ae92fb6fccf442b2ae25df9d10bea2ab455f81165a3b2b554b097b2d"
    sha256 cellar: :any_skip_relocation, ventura:       "0982090f6d9c96ce7cff3fe657a821be958d466a9fa3e22887f4cb2111523419"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c098f3480e7bcc0122689e66db4dbb71ca591891e8f8e3091d6e744a2fec48a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c5729f0c726dfe3a4b0cff7dbf3e149c07e392d260db707c99a80ed0b0e4264"
  end

  depends_on "rust" => :build

  def install
    # Upstream uses qemu to cross compile for Linux aarch64, which is not desirable in brew.
    # https://github.com/shssoichiro/oxipng/commit/1f2e0f336a826bd578a49c1dd477fb38773dd6ce
    #
    # cargo allows setting the variable to some other non-empty string, but not fully
    # unsetting it, so remove the assignment from the source file.
    # https://github.com/toml-lang/toml/issues/30
    # https://doc.rust-lang.org/cargo/reference/config.html#environment-variables
    # https://doc.rust-lang.org/cargo/reference/config.html#command-line-overrides
    inreplace ".cargo/config.toml", "runner = \"qemu-aarch64\"", ""

    system "cargo", "install", *std_cargo_args
    system "cargo", "run",
           "--manifest-path", "xtask/Cargo.toml",
           "--jobs", ENV.make_jobs.to_s,
           "--locked", "--", "mangen"

    man1.install "target/xtask/mangen/manpages/oxipng.1"
  end

  test do
    system bin/"oxipng", "--pretend", test_fixtures("test.png")
  end
end
