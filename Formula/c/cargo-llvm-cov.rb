class CargoLlvmCov < Formula
  desc "Cargo subcommand to easily use LLVM source-based code coverage"
  homepage "https://github.com/taiki-e/cargo-llvm-cov"
  # cannot use github tarball due to https://github.com/taiki-e/cargo-llvm-cov/pull/152#issuecomment-1107055622
  url "https://static.crates.io/crates/cargo-llvm-cov/cargo-llvm-cov-0.6.10.crate"
  sha256 "8c9f81a298cfd7bf22c7bfd09475859ee6408c056ddace5749bc6f87dbeb4ffa"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/taiki-e/cargo-llvm-cov.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "698f3db7d75323cce14851bf327fd1d714fb4b2385413c4303941c359bd49c17"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2faf4fd990b6d19f8b56634f575e9b7e5703e8a37b827311e279d070fdd204de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "667f12398d28c6e0b74e40aa5ae5a35303f733e64caf52104ab3889a60165bd0"
    sha256 cellar: :any_skip_relocation, sonoma:         "9b50e2ed19041c60f95bef542ab4c63512360ff20da34d2214949f8c4380894c"
    sha256 cellar: :any_skip_relocation, ventura:        "d646d239489a2d441dcbc52c83b17e0afbc6bccb0760d0949d824ee450147755"
    sha256 cellar: :any_skip_relocation, monterey:       "a366f33322957659e51409961352ee4877c5547d65e03c3c58f165e987878eae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5de50e4bbde86ad7f1c4f7b1e3232901850f50ccb44d193dbb7a2a3715da27ee"
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

    system "cargo", "new", "hello_world", "--lib"
    cd "hello_world" do
      system "cargo", "llvm-cov", "--html"
    end
    assert_predicate testpath/"hello_world/target/llvm-cov/html/index.html", :exist?
  end
end
