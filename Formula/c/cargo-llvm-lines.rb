class CargoLlvmLines < Formula
  desc "Count lines of LLVM IR per generic function"
  homepage "https://github.com/dtolnay/cargo-llvm-lines"
  url "https://github.com/dtolnay/cargo-llvm-lines/archive/0.4.34.tar.gz"
  sha256 "0068de412343dcf47b53abee9600713ae565aa6f43f39212ef94db50d0c29cb9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-llvm-lines.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "264c64c1a098b15956a63d7ef9c3b992806ffa56393dc109a53c78856fa0b199"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41c3affa27c139326ef43541969c45d5881d412547c724574b37906a1f91aece"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "223e4efc1ca26d811077dbc3a6eb274fe5e4523cb3c83ca9768966c551fa79d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d82da5c6b9aa2e16cd7ac04c10d097b74880ada3e8d38d1727fdaeca43770cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "1c794021500eb2eaae74d151c3e7aa0d6026d62c5d5734dd54a86d21470a0650"
    sha256 cellar: :any_skip_relocation, ventura:        "2f4cca6fe9fa61d1ccf2478d30223daa46c10a0a19c7f6bd5f1f3e32522efc68"
    sha256 cellar: :any_skip_relocation, monterey:       "e916b786091b298b3d45b464435c3a672550ada111ffbe6904c9ed77fffe1de8"
    sha256 cellar: :any_skip_relocation, big_sur:        "44cab04b2843015588f586120c7269a37dbba65d0cfd8916eecd63feece23aad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b04ed2c97d3130483d8e373d15f2f38edaaf1c5e09805361360ff0e1c7fa09fb"
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
