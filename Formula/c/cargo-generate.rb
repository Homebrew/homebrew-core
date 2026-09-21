class CargoGenerate < Formula
  desc "Use pre-existing git repositories as templates"
  homepage "https://github.com/cargo-generate/cargo-generate"
  url "https://github.com/cargo-generate/cargo-generate/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "972a7083b97e8a0e6fae8a0c2b2fbc15f15369acebb1902ddadc93dc0deb9c09"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/cargo-generate/cargo-generate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a59646b1430768b26e15559c4af6b4dbffd13fd671cb760dbc67801b9b34774d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "086df390b02c840d1dccbb8c51dfe65f48f0965021e6294500e2140ae6398bec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6651701a20cb037bc0db288371fbad115f37f6d9d5832fe75fba779a54551ccc"
    sha256 cellar: :any,                 arm64_linux:       "64b9ebcf373d66035d014a3d6108a70fcfab17573eeabbc8430d3c5dda8235f4"
    sha256 cellar: :any,                 x86_64_linux:      "b1b934f16e6137cd047c7cc5e92c4cbd783c2b0b5f1eea6f0d4adcb7fb1d8841"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "No favorites defined", shell_output("#{bin}/cargo-generate gen --list-favorites")

    system bin/"cargo-generate", "gen", "--git", "https://github.com/ashleygwilliams/wasm-pack-template",
                                 "--name", "brewtest"
    assert_path_exists testpath/"brewtest"
    assert_match "brewtest", (testpath/"brewtest/Cargo.toml").read
  end
end
