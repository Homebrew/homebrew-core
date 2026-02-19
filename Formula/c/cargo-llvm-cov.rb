class CargoLlvmCov < Formula
  desc "Cargo subcommand to easily use LLVM source-based code coverage"
  homepage "https://github.com/taiki-e/cargo-llvm-cov"
  # cannot use github tarball due to https://github.com/taiki-e/cargo-llvm-cov/pull/152#issuecomment-1107055622
  url "https://static.crates.io/crates/cargo-llvm-cov/cargo-llvm-cov-0.8.4.crate"
  sha256 "3df082077af932cde39d8434e1ab147f80bda1f9fc4da64a699b109f897fcd63"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/taiki-e/cargo-llvm-cov.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e67ce90a7637b055de07255fb9512ab7caf8f1f0acc27acb5932870f6ea92ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c91d1a223aebc402aaa568db65c973eb941cda5237d77858fa1b4941252a30c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2220b7bfc3048efb6fa941a2115c1c0b190437b4499a314ad4b1da6dcacea43f"
    sha256 cellar: :any_skip_relocation, sonoma:        "14a9d95ec65cc7bc0ecd3cf6cf60746d2ede1ee6b7dd4b76df5041c06f2d0070"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bcfe0b46b6cdb294a6366752910a539d7fe1f17b403314dab327ab7e67f43ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92fa7ddbc2bece1ac2d6a6d357d54a00f13757dd6544651060a678c49c89fb89"
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
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    system "cargo", "new", "hello_world", "--lib"
    cd "hello_world" do
      system "cargo", "llvm-cov", "--html"
    end
    assert_path_exists testpath/"hello_world/target/llvm-cov/html/index.html"
  end
end
