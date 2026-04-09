class Anchor < Formula
  desc "Solana Program Framework"
  homepage "https://anchor-lang.com"
  url "https://github.com/solana-foundation/anchor/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "1cce1e7765543ca2503842230aa54eef2fead7b2f533cdd540a79a99b560f59b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8dc41ce4d13003d37fa347ad5f8c7dbbeaaf5a4dffe0e8d0330ab4d6acfe0cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb78bdb7d5ea97341f6f8261e6934f85a866fba9078f2763f745dd3b5c1b3740"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d36e71597e79519681b4cc1b3a44ac8b4330b2007b20106532bad6e69e125d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac0c0703d8a45514a1021c5c3fcead0faa69eeb621f5f0eb93bf863c1b916b39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7195c91457ce8a7f38d47b7c29c97e5f3a76f2d4a7e18d157367f3ea8ecadc92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b970138b57cc4159b18861d07e14f1d3155719c1d9d985e2e94e0c3c0dbd8d75"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "node" => :test
  depends_on "yarn" => :test
  depends_on "openssl@3"

  on_linux do
    depends_on "systemd" # for `libudev`
  end

  def install
    # FIXME: "Unknown attribute kind (102) (Producer: 'LLVM21.1.8' Reader: 'LLVM APPLE_1_1600.0.26.6_0')"
    inreplace "Cargo.toml", "lto = true", "lto = false"

    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin/"anchor", "completions", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match "anchor-cli #{version}", shell_output("#{bin}/anchor --version")
    system bin/"anchor", "init", "test_project"
    assert_path_exists testpath/"test_project/Cargo.toml"
    assert_path_exists testpath/"test_project/Anchor.toml"
  end
end
