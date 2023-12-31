class CargoAbout < Formula
  desc "Cargo plugin to generate list of all licenses for a crate"
  homepage "https://github.com/EmbarkStudios/cargo-about"
  url "https://github.com/EmbarkStudios/cargo-about/archive/refs/tags/0.6.0.tar.gz"
  sha256 "b2967f406d68cb09dff8ffea4f60c398ad873a41ac19e6a841e30e22c730791d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-about.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7272b769961c55d1242e89cc9b62c0864d724f6cd347d30865777b89e76f88e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c26661a4ab919549ea41b94e28b78d88bacc25975ee56a78bc98b7e73fba6543"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60418c9ae3977ff0acc6f8de317c14db976033fed0204d215d8cc580c8678d63"
    sha256 cellar: :any_skip_relocation, sonoma:         "2d324ce6051f00eb79559a50e1680ea610e6cc931d55a356be5a13159cd5c1d6"
    sha256 cellar: :any_skip_relocation, ventura:        "e2713fcebcd3b6141c445471abac934723ce3bc7c02ee8e806fc7651c3d67c48"
    sha256 cellar: :any_skip_relocation, monterey:       "43c32675e6cbb009794ecd0f723d190dc9e8c18257ad34a3838b75c7451aed78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21cf1dcbecb204ca13ced40d88daadc727e718a9b74e40f34f9738519f906e09"
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
        license = "MIT"
      EOS

      system bin/"cargo-about", "init"
      assert_predicate crate/"about.hbs", :exist?

      expected = <<~EOS
        accepted = [
            "Apache-2.0",
            "MIT",
        ]
      EOS
      assert_equal expected, (crate/"about.toml").read

      output = shell_output("cargo about generate about.hbs")
      assert_match "The above copyright notice and this permission notice", output
    end
  end
end
