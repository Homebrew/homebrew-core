class CargoGenerate < Formula
  desc "Use pre-existing git repositories as templates"
  homepage "https://github.com/cargo-generate/cargo-generate"
  url "https://github.com/cargo-generate/cargo-generate/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "13b6037d031d411135a1c991615d8305e4e2993ab0a8854e0e6d453280ae3949"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/cargo-generate/cargo-generate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cbfe72651856266cef66c4a5586f591cb869a18864790b34e44bc78bc3277723"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "26d1e89a86f50f11e5e0b1c32a74a5882156f9668624b406cd51f4a1cd2e393c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5b9d2f0c148e77af6ccb33560d87bb11f62496a1d65e592f67ad2fd0054fa1ea"
    sha256 cellar: :any,                 arm64_linux:       "61260c0914861144318fcf4719313490c65d180ecbdc901aef002499da27af19"
    sha256 cellar: :any,                 x86_64_linux:      "e7c55d4a450481b6b17b5c4a49e706134b8af94b55697c98cbef3202e3a7023e"
  end

  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "No favorites defined", shell_output("#{bin}/cargo-generate gen --list-favorites 2>&1")

    system bin/"cargo-generate", "gen", "--git", "https://github.com/ashleygwilliams/wasm-pack-template",
                                 "--name", "brewtest"
    assert_path_exists testpath/"brewtest"
    assert_match "brewtest", (testpath/"brewtest/Cargo.toml").read
  end
end
