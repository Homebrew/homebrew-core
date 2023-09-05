class CargoDepgraph < Formula
  desc "Creates dependency graphs for cargo projects"
  homepage "https://sr.ht/~jplatte/cargo-depgraph/"
  url "https://git.sr.ht/~jplatte/cargo-depgraph/archive/v1.5.0.tar.gz"
  sha256 "6826402ec9b8f2e942954ae0cfe9848cc4d2aa3d98ff89bee05bdeed787d66bb"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a85fe08115630edfbf6ca9e45fb992dad14764216b5a7a95d6a6618043c35e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ccfb07e2c8f69244373ca5260b7d8ec5a412ff0028136756e8b4ede03a55f6f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f6c261795d2024686bb9e5a4fb2a66a87cfc03568fabf13569d656838caa0ef"
    sha256 cellar: :any_skip_relocation, ventura:        "93a09afedffc4580f76060a16599508730f77b56ecc4ebab6442ba16b6e93b1d"
    sha256 cellar: :any_skip_relocation, monterey:       "51bdc864ae900348f1a5cf5609fb30d35d754d9e8626da25a70e06737b6983f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "eac46431eac8ddec19b2f6de50bd359e018ffd8eedcb2abfc9d350c3ce74dc12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25545f8c3c417ba66ee53eab0be6751601e46c7ee287a265ca6b50f0d0b28782"
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

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write "// Dummy file"
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [dependencies]
        rustc-std-workspace-core = "1.0.0" # explicitly empty crate for testing
      EOS
      expected = <<~EOS
        digraph {
            0 [ label = "demo-crate" shape = box]
            1 [ label = "rustc-std-workspace-core" ]
            0 -> 1 [ ]
        }

      EOS
      output = shell_output("#{bin}/cargo-depgraph depgraph")
      assert_equal expected, output
    end
  end
end
