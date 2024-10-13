class CargoAllFeatures < Formula
  desc "Cargo subcommands to build and test all feature flag combinations"
  homepage "https://github.com/frewsxcv/cargo-all-features"
  url "https://github.com/frewsxcv/cargo-all-features/archive/refs/tags/1.10.0.tar.gz"
  sha256 "07ea7112bf358e124ecaae45a7eed4de64beeacfb18e4bc8aec1a8d2a5db428c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/frewsxcv/cargo-all-features.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a3230194ce2a1aaf67cf633477a254f8bea2e1661c6849598c31e1e9dee4866a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b12a3968ae8ee10062526525c6cc07c5d288529204b51696e9f3ea104dffb1f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d72b4b7f454143ec36fbaa284c2564c60c97ed8eb0de568e634c18dc485284c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d399885e0cc2a32003b98de866fc80c9c74b3aeac8a8254ad9c40d1d617a36fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "50e52b0f7d74b369aebb9809cb318cf03a13c2161b95059810c53bab6698ed4c"
    sha256 cellar: :any_skip_relocation, sonoma:         "482a7cfad0c83737225ad19497e41ff876434fd9c2ebcf05a9f7c7f452931ebb"
    sha256 cellar: :any_skip_relocation, ventura:        "39177b01645bfdf19d6d9757c863e96bdd711170d8e87a1f5b2c7d9720f0a33a"
    sha256 cellar: :any_skip_relocation, monterey:       "912aeeaf3ae966f434cacda0b8e5c5c904f8ad83d33ff3334724c3022e151185"
    sha256 cellar: :any_skip_relocation, big_sur:        "680c7a563c12800a68c8e24afbad0b5c8ca8380c7e16e5e2a4f045af3bae7406"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b948efbbe607b8dd394c6051416e698544960ece99c29c67909228214e3f1c17"
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
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write <<~EOS
        fn main() {
          println!("Hello BrewTestBot!");
        }
      EOS
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"
        license = "MIT"
      EOS

      output = shell_output("cargo build-all-features")
      assert_match "Building crate=demo-crate features=[]", output

      output = shell_output("#{bin}/cargo-build-all-features --version")
      assert_match "cargo-all-features #{version}", output
    end
  end
end
