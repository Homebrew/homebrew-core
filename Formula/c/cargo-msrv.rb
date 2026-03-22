class CargoMsrv < Formula
  desc "Find the minimum supported Rust version (MSRV) for your project"
  homepage "https://foresterre.github.io/cargo-msrv"
  url "https://github.com/foresterre/cargo-msrv/archive/refs/tags/v0.19.2.tar.gz"
  sha256 "d8f49750341ef780d9799892921a2db46f309ffcf3f957c28cb6e1e65d73549f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/foresterre/cargo-msrv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f189ee5f9b655754234e7812eaa143e44bd98592397b9554bb8479e0b4e90ccd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1de216a97f13ef67ad3e5a2cd2f1723e17e34101f9638b387ab430048a705513"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7055c7c672f29e25cb4b5be9cfbe432a1c59dc41f2b64ac99be0af7215d75f0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "13e2dc40edc1d775eeca96af7af28ecfd753d50e61e3e054acc7d1ad74a0bbd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "906f3a07a6fa42a61c9916c85887238da5634db462f9e72364820bb7f47149ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e415f199164c50d0fde49c29bca746785fa77a68578723dba57aeb4be478417"
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
