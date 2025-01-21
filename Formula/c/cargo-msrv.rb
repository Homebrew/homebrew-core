class CargoMsrv < Formula
  desc "Find the minimum supported Rust version (MSRV) for your project"
  homepage "https://foresterre.github.io/cargo-msrv"
  url "https://github.com/foresterre/cargo-msrv/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "b9e628ab70bbd008da0c57ba3d0f4f66c5fcc1cd694de5ec970a363cce780c06"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/foresterre/cargo-msrv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8083a067bcac304b1f84110555863bb37cacc040d08812f1521998d36d3600e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ec7c44782080181ec1cfe6c80dc4b623ce910856a1a47ae4c342de2c58f9afe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "37d436e976955a03374cdcd1562d79b9c93f0373a416943c4939f45f63e6d0a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "69f34989b88de9b80b0294b0db5e477740b6e5e46974a1c906998ae380cf6f14"
    sha256 cellar: :any_skip_relocation, ventura:       "9be524682f16b37d3b403bc94042fbee0c59225890bbcca9b7a0b5fb5a057e65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb3027915726759404e1ff5e842e4c0950edb8be93b229057df42bf261a5e911"
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
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

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
