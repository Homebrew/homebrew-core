class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https://github.com/EmbarkStudios/cargo-deny"
  url "https://github.com/EmbarkStudios/cargo-deny/archive/refs/tags/0.14.21.tar.gz"
  sha256 "74c935972fedf4e22035c16bd0116e2b2cdf6836c3746f1c6115f5fc447e16a9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dee92d55def973f2d797cb9d7028f20aeb49251305ae052f83e5357907065840"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bdd828215ab44e9fde0149b2260e0e2cecdc7b41ec70b682adc673001f923233"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9e069f27373e0767b9776c9f7b8895a0273c8b249129f92f2c5f74f48e65527"
    sha256 cellar: :any_skip_relocation, sonoma:         "89591ca0c6a438e9bf6adeda6e2bc6194ae672fe7a652e37197af17ed06caa61"
    sha256 cellar: :any_skip_relocation, ventura:        "36f6efa54a8791cd622a5bd2172e0575319e98f0f31991951b07b13369eb8e3b"
    sha256 cellar: :any_skip_relocation, monterey:       "577bcc69af82cc3d647e00e02b5196b78066d747d99af469b67a42c7498dd787"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54dde18cf05837c6e03e96b65c330d4ed3d160a2aaee9a575372e21b34ec95d4"
  end

  depends_on "pkg-config" => :build
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
      (crate/"src/main.rs").write <<~EOS
        #[cfg(test)]
        mod tests {
          #[test]
          fn test_it() {
            assert_eq!(1 + 1, 2);
          }
        }
      EOS
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"
      EOS

      output = shell_output("cargo deny check 2>&1", 4)
      assert_match "advisories ok, bans ok, licenses FAILED, sources ok", output
    end
  end
end
