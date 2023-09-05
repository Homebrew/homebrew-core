class CargoWatch < Formula
  desc "Watches over your Cargo project's source"
  homepage "https://watchexec.github.io/#cargo-watch"
  url "https://github.com/watchexec/cargo-watch/archive/v8.4.1.tar.gz"
  sha256 "af1b649de787630144ccbb510b854d2e2a21b91df6cc7e0f420fd14518978572"
  license "CC0-1.0"
  head "https://github.com/watchexec/cargo-watch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68731e71cd0a425c94927e77db4c4db0b7ecb277657f4e628f4f76bfb9934a20"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f527865af1bafdfa3fe513ee67a2d8a17ed5265ab38b01252aad706a9375b961"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f8215440196c9fb03ceba5855a5aa5e11e34d4143c51ba6a257ef171bbeb0125"
    sha256 cellar: :any_skip_relocation, ventura:        "ee77327792a8df29211b7aa76852f92da76d00dda669d595e2b54c311aa6beb5"
    sha256 cellar: :any_skip_relocation, monterey:       "36dcd5778de148e8a6059143390583bf15d5e74a50833c21527f844c94b8a205"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1f46ca93af6f011804a06e70835f923c8c138804ca95155eb799dafd247a50d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6774ed87cdf323a41020585d3cd20c6410327dc0d05858c1751333029149e900"
  end

  depends_on "rust" => :build
  depends_on "rustup-init" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    rustup_init = Formula["rustup-init"].bin/"rustup-init"
    system rustup_init, "-y", "--profile", "minimal", "--default-toolchain", "beta", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

    output = shell_output("#{bin}/cargo-watch -x build 2>&1", 1)
    assert_match "error: project root does not exist", output

    assert_equal "cargo-watch #{version}", shell_output("#{bin}/cargo-watch --version").strip
  end
end
