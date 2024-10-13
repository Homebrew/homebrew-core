class CargoLlvmCov < Formula
  desc "Cargo subcommand to easily use LLVM source-based code coverage"
  homepage "https://github.com/taiki-e/cargo-llvm-cov"
  # cannot use github tarball due to https://github.com/taiki-e/cargo-llvm-cov/pull/152#issuecomment-1107055622
  url "https://static.crates.io/crates/cargo-llvm-cov/cargo-llvm-cov-0.6.14.crate"
  sha256 "35c0d03a4d743b37e0be9dc160214f94a2450a01a1ea01d9f5b677444d53a91f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/taiki-e/cargo-llvm-cov.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fb1c743faa648d450895cd907a4920dcc7a93ef4fe9033c9aa4312c43a1067b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd65997c837ef86b3f9b6cb018494eca4e98d447b6d79ca0c552ab226c921423"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "648c08e0cbd72fb82936c255f7fdc8cb37e342333e3fa8b98227025765ce3a7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7be890f1fd9a393278cd9c83073e51ec3f59cf5650289ce9ecf074f4b2e1da17"
    sha256 cellar: :any_skip_relocation, ventura:       "d6897167796fa41791437bc883621d7b230e6ca24d5431e103213c4cadc9ef8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e95a0baa6ec312823ba1dd983c9764499a83bd788b12f5cd4f0a8806f500bfdd"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

    system "cargo", "new", "hello_world", "--lib"
    cd "hello_world" do
      system "cargo", "llvm-cov", "--html"
    end
    assert_predicate testpath/"hello_world/target/llvm-cov/html/index.html", :exist?
  end
end
