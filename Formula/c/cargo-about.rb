class CargoAbout < Formula
  desc "Cargo plugin to generate list of all licenses for a crate"
  homepage "https://github.com/EmbarkStudios/cargo-about"
  url "https://github.com/EmbarkStudios/cargo-about/archive/refs/tags/0.6.2.tar.gz"
  sha256 "e2efd2b75c3079d4fb770a7aeba52e8e5a98f184a91b521ada607bc712537f65"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-about.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "55c99a186b5765430bc0182f944ef0dca2df03165fc735779e32a85b6ab0e374"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af94b6208b6b07923e18368a96910358f5620196aa104821397716119473f22a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6964338022e14329f0176e382190d1b5fa838e93c0f7e6951cbf7309e5772e00"
    sha256 cellar: :any_skip_relocation, sonoma:         "6de78c45d06a7cb255195ba7aa6ef5528c4dcaacfbbcf8bec04d7e1364ee3343"
    sha256 cellar: :any_skip_relocation, ventura:        "7bb44dcb2c247302d0afde1cc4337100f2769bf1f92fc35712a2f0c11e8e533c"
    sha256 cellar: :any_skip_relocation, monterey:       "ef8c35352194b21ee3b9582ed4e4db5e1d1fd8cc8c0559ed1f0c5b49257ac163"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45866102093af40beb7254b2ea3d365199396b81aa93b358eac5497d61335449"
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
