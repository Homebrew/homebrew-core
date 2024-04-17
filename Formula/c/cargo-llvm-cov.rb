class CargoLlvmCov < Formula
  desc "Cargo subcommand to easily use LLVM source-based code coverage"
  homepage "https://github.com/taiki-e/cargo-llvm-cov"
  # cannot use github tarball due to https://github.com/taiki-e/cargo-llvm-cov/pull/152#issuecomment-1107055622
  url "https://static.crates.io/crates/cargo-llvm-cov/cargo-llvm-cov-0.6.9.crate"
  sha256 "137c054c19f1134aabe426018c3d8718ff5cfe679ba895f3f0a869eccf8b380b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/taiki-e/cargo-llvm-cov.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "248b2e966708b5498e1f5471b70c69cc9a3a39afa6cfdeaf7d2124d3193823d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e85b08c4c6c35a7751860d94d43269cbd0d1288637bd407933f0f7e64141f48b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa0f27ebc3e2a863e0e363f05e7f086e30b85604b421c46ce65c4714f7a53c13"
    sha256 cellar: :any_skip_relocation, sonoma:         "5b251fd14c28599d9b959f192d3f489d44cde1545ba81c17d11213c80e535a22"
    sha256 cellar: :any_skip_relocation, ventura:        "76ff088a4a018c1d2aba546fb21a607e5c2c2e5d0291d37a234c4435f3115917"
    sha256 cellar: :any_skip_relocation, monterey:       "eea85e9d4b7db6b5f4fb7c5e39d34945e8da5fa28121434fc53618d16e24a908"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea8b52628afed55adf45feca5059ae8a604a7d789f4d84807d58dc00f235510f"
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
