class CargoLlvmLines < Formula
  desc "Count lines of LLVM IR per generic function"
  homepage "https://github.com/dtolnay/cargo-llvm-lines"
  url "https://github.com/dtolnay/cargo-llvm-lines/archive/0.4.33.tar.gz"
  sha256 "7faa35c628da3290f5fdac06273e406203bf3e294e6363643bf9fc286d602f68"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-llvm-lines.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17a2e5332b4201da97c2ae34d16f80c11a1d7cc9845d3988d40c75789f394356"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01cee61a90e7aaedd5c3b8c20bdc66aeb09157d078cd8ed17d6d40e06e0a86ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc2dc6308aa6df622bc7abf7987e408ad3b75c77a760fcb932e7268428aa1c42"
    sha256 cellar: :any_skip_relocation, ventura:        "ce3f267f285a41af31c9073e17b1d74e39b09f12533383351c3fef5c0fe6c044"
    sha256 cellar: :any_skip_relocation, monterey:       "e93d110abe51109c72cc74c2c5e81060da98cd767109d4ae45b7399bc114e132"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ad8bc707b4c7dae97289f585a1f1a32a5e69921a500f43724aa7a3ce4fb8da8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "133c14b98aefac74831f61fcc4519a2d0f7769a53415c40508aa9c998a575045"
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
