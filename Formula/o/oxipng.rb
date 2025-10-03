class Oxipng < Formula
  desc "Multithreaded PNG optimizer written in Rust"
  homepage "https://github.com/oxipng/oxipng"
  url "https://github.com/oxipng/oxipng/archive/refs/tags/v9.1.5.tar.gz"
  sha256 "8f99d5c67efa2a7550023bf610b90e65d421375c9ed7f37097f83ae5c05f85bd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fed9aa78c4a1e95303dcdb8fb95fb4c36b3fa6134866c70bb53c192b047129e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6eed490e9f3c9a9668213862587fed4ec27f6aa1230a5556618bc7e3de86b9a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "865784029579b8c2b4446dba962ef46379c015c554cf7f99bcdb20b94fb8b9a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2c4e48bbdb999086c8a73ceaf4bc3d1fb88e61f044bdcb0b37e21277a952cd07"
    sha256 cellar: :any_skip_relocation, sonoma:        "a30bed265b000ba4a8ae568c40244ba8005b9cf9d8afaa41da56ba42759b3831"
    sha256 cellar: :any_skip_relocation, ventura:       "ce9a889f4f0df4bddaf29a866971bbabc78c35a32c07807ab3e0a8f57668a0c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3d37e577eb6aa04680c7714a307eeb1714ac3bd9eb46d25b48dec8819983356"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d810a1834a72c9c2ae54ff64a67c6fd0f6100e70d52dac77ca1638b80327ab17"
  end

  depends_on "rust" => :build

  def install
    # Upstream uses qemu to cross compile for Linux aarch64, which is not desirable in brew.
    # https://github.com/oxipng/oxipng/commit/1f2e0f336a826bd578a49c1dd477fb38773dd6ce
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
