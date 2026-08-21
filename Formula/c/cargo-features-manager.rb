class CargoFeaturesManager < Formula
  desc "TUI like cli tool to manage the features of your rust-project dependencies"
  homepage "https://tangled.org/tobinio.dev/cargo-features-manager"
  url "https://static.crates.io/crates/cargo-features-manager/cargo-features-manager-0.12.0.crate"
  sha256 "cbfa8ceb9b52aff46d6122c97752e1cc0a638c028e676159ebff11128f0cf333"
  license "MIT"
  head "https://tangled.org/tobinio.dev/cargo-features-manager.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8159619cb9d57546837377328b34f49d80144cb6d897885aa93ce405741ce182"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e04dd0616f9de191578403a1eeeab8ec1f4b7675572422f468d8756f10f109fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e13fd59d484963c92821e518293e5964674b9c61fb17b04c02cc71bb27f0cd2"
    sha256 cellar: :any_skip_relocation, sonoma:        "73c14ac82ced26b9561709d10cdd35cd8ee9280155c4fda212a9824fb434f6a2"
    sha256 cellar: :any,                 arm64_linux:   "090421d6a956ba8c44a7752ffd89f3a429e0d83e8fa8011eae3d3dbb43d18799"
    sha256 cellar: :any,                 x86_64_linux:  "91b99769481b321156764e94ccf5c48c49537a1adda5248dcc4886db0e94693c"
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

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [lib]
        path = "lib.rs"

        [dependencies]
        libc = "0.1"
        bear = "0.2"
      TOML

      (crate/"lib.rs").write "fn main() {}"

      output = shell_output("cargo features prune")
      assert_match "workspace [1]", output
      assert_match "libc [0/1]", output
    end
  end
end
