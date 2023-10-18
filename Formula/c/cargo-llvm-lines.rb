class CargoLlvmLines < Formula
  desc "Count lines of LLVM IR per generic function"
  homepage "https://github.com/dtolnay/cargo-llvm-lines"
  url "https://github.com/dtolnay/cargo-llvm-lines/archive/0.4.36.tar.gz"
  sha256 "7b38c20001dfa5012ea2d2a4050d297cdd335df727d7867545a3682ccbb53de5"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-llvm-lines.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2c635b48b3fd2382b832a0aa51966612e7b10d9e19d37c52a75fb380509fa6aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be6a0183c0351ace9860339243872af6b724008b44d5592fc570c1130539fd92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60f12c6b75c64fb2b86cbbda0c45f58c2e9cf5b67d17a49d78e079129c90c76c"
    sha256 cellar: :any_skip_relocation, sonoma:         "d7cd3a7066c5cd6654f0c506c6f4e1cf364eb9eea1eaa963961e7a369af770b6"
    sha256 cellar: :any_skip_relocation, ventura:        "e9f37e5ddcefd235e9fd6779b269103c99fddeb31eaf75740288c648e7182fe0"
    sha256 cellar: :any_skip_relocation, monterey:       "d601ce9b6d9088bef889e59c7c97b861db84c8b6405aaaf2c87c421852adf36e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8544f9fb10b308e6a6ebc8ce6037d27184739f77fc92de3688d71f1e910402c4"
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

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      output = shell_output("cargo llvm-lines 2>&1")
      assert_match "core::ops::function::FnOnce::call_once", output
    end
  end
end
