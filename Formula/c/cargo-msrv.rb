class CargoMsrv < Formula
  desc "Find the minimum supported Rust version (MSRV) for your project"
  homepage "https://foresterre.github.io/cargo-msrv"
  url "https://github.com/foresterre/cargo-msrv/archive/refs/tags/v0.19.3.tar.gz"
  sha256 "b5a66ccd44e7f28bae070a730d315b71bbca727b7ea558db9af93ab23e703883"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/foresterre/cargo-msrv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d09bad53b1c25eae5a27275c4f09c8b4bd2c51c5903c15128f55bd6b0530dfc9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "825fb00050c312c391d40fc958ca2e6e2b94462fd1d1c10facbf05a58e313d32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65327c59fc5c3f2617cc71b6b5162ea4997b48bcdd6b90a945277bd77e668a4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "169dc4d52e971a7bb085f8ba167bb169ee04e64b42abab3e84a324fdea294b03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cfc25fa3873fb3eec306edd674660ca76cddfa5c0a6187ca3bfb29cd46f03e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0c5646166caad838c63ed6c446c6235759b8622df2e7f70b15e794b99df893a"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["NO_COLOR"] = "1"

    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    assert_match version.to_s, shell_output("#{bin}/cargo-msrv --version")

    # Now proceed with creating your crate and calling cargo-msrv
    (testpath/"demo-crate/src").mkpath
    (testpath/"demo-crate/src/main.rs").write "fn main() {}"
    (testpath/"demo-crate/Cargo.toml").write <<~EOS
      [package]
      name = "demo-crate"
      version = "0.1.0"
      edition = "2021"
      rust-version = "1.78"
    EOS

    cd "demo-crate" do
      output = shell_output("#{bin}/cargo-msrv msrv show --output-format human --log-target stdout 2>&1")
      assert_match "name: \"demo-crate\"", output
    end
  end
end
