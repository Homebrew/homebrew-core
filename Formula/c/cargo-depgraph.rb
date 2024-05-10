class CargoDepgraph < Formula
  desc "Creates dependency graphs for cargo projects"
  homepage "https://sr.ht/~jplatte/cargo-depgraph/"
  url "https://git.sr.ht/~jplatte/cargo-depgraph/archive/v1.6.0.tar.gz"
  sha256 "79f7425bc37c59fc4b083bdc35f43d29c2078b427ec6bb30565a4c04841ce364"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "060ce6579e0acf883ca67a613d5f33375205e56afa48a28876d81d9d653d275e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "694d37c938b1aea59687cda71bea7a8fba0656b191b716a3e8d58a71c2fec02f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12ed5d4719fecb87d5a71f1bb8f82d574c3b5ba77d990430874aa49a33b9cdae"
    sha256 cellar: :any_skip_relocation, sonoma:         "b1f53651402919895849ba1d0a98940b941a1b35acbb75c1f8371ebdff55e8c7"
    sha256 cellar: :any_skip_relocation, ventura:        "2e44d01ca28d59eb203a1cc88f7f5037d755438880164a4c918062e453ed9898"
    sha256 cellar: :any_skip_relocation, monterey:       "8e01617fefdb9893ecf0ab91f8568ca65657e49aee84f48afd47957c8d7bd223"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df3185c78ab12934b6ebf2d15a4bbf0eb110774fbae01d4e10a2133ac8ba0039"
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
