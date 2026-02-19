class CargoMsrv < Formula
  desc "Find the minimum supported Rust version (MSRV) for your project"
  homepage "https://foresterre.github.io/cargo-msrv"
  url "https://github.com/foresterre/cargo-msrv/archive/refs/tags/v0.18.4.tar.gz"
  sha256 "9e8d743a9948ec91e4d82ce34b8f0f9e65385ed78739cb36376f65049d8b8da5"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/foresterre/cargo-msrv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c933cc8a8c2df5edcef6dd3eb66a17b7004d358d855d0409237cf69fbf2401d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a51548c6d0b81c3dd24e17569505ad9cb6760a5dbc111fa9dc4993f162ca0eca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "813162996051721d05770fdc9ed7f8878c76ba57e12e9525e9a3547bbc4356e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a4ae3bbd41c2cbd23e07ccd1c26f8ea854d63bc49daf043384ad980029268f2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "45e5d88a23f0d0f1dfc83b86a6d7425008d0a86ad21520fc9a42837fd9de3cfa"
    sha256 cellar: :any_skip_relocation, ventura:       "b0048b375dbdcd010ac19829bc4d5b2733819578ebb2880f8cd772f72f88df53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7e2393546f7f2b9a3cad3db9803e4c9a1bbdf83f2cf5e2a0cad963f1a03b930"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea9a3477964f0e30b7cae9881998f0f0520cf254e382e1c9680dbbe412d4bb89"
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
